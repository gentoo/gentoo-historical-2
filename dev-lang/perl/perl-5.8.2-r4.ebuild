# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/perl/perl-5.8.2-r4.ebuild,v 1.3 2005/03/20 10:48:41 mcummings Exp $

inherit eutils flag-o-matic gcc

# The slot of this binary compat version of libperl.so
PERLSLOT="1"

SHORT_PV="${PV%.*}"
MY_P="perl-${PV/_rc/-RC}"
DESCRIPTION="Larry Wall's Practical Extraction and Reporting Language"
S="${WORKDIR}/${MY_P}"
SRC_URI="ftp://ftp.perl.org/pub/CPAN/src/${MY_P}.tar.gz"
HOMEPAGE="http://www.perl.org/"
SLOT="0"
LIBPERL="libperl.so.${PERLSLOT}.${SHORT_PV}"
LICENSE="Artistic GPL-2"
KEYWORDS="x86 amd64 sparc ppc alpha mips hppa ia64 ppc64"
IUSE="berkdb debug doc gdbm ithreads perlsuid uclibc"

DEPEND="!uclibc? ( sys-apps/groff )
	berkdb? ( sys-libs/db )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	>=sys-devel/libperl-${PV}
	!<dev-perl/ExtUtils-MakeMaker-6.17
	!<dev-perl/File-Spec-0.84-r1
	!<dev-perl/Test-Simple-0.47-r1"
RDEPEND=">=sys-devel/libperl-${PV}
	berkdb? ( sys-libs/db )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )"

pkg_setup() {
	# I think this should rather be displayed if you *have* 'ithreads'
	# in USE if it could break things ...
	if use ithreads
	then
		ewarn ""
		ewarn "PLEASE NOTE: You are compiling perl-5.8 with"
		ewarn "interpreter-level threading enabled."
		ewarn "Threading is not supported by all applications "
		ewarn "that compile against perl. You use threading at "
		ewarn "your own discretion. "
		ewarn ""
		epause 10
	else
		ewarn ""
		ewarn "PLEASE NOTE: If you want to compile perl-5.8 with"
		ewarn "threading enabled , you must restart this emerge"
		ewarn "with USE=ithreads emerge...."
		ewarn "Threading is not supported by all applications "
		ewarn "that compile against perl. You use threading at "
		ewarn "your own discretion. "
		ewarn ""
	fi

	if [ ! -f "${ROOT}/usr/lib/${LIBPERL}" ]
	then
		# Make sure we have libperl installed ...
		eerror "Cannot find ${ROOT}/usr/lib/${LIBPERL}!  Make sure that you"
		eerror "have sys-libs/libperl installed properly ..."
		die "Cannot find /usr/lib/${LIBPERL}!"
	fi
}

src_unpack() {
	unpack ${A}

	# Get -lpthread linked before -lc.  This is needed
	# when using glibc >= 2.3, or else runtime signal
	# handling breaks.  Fixes bug #14380.
	# <rac@gentoo.org> (14 Feb 2003)
	# reinstated to try to avoid sdl segfaults 03.10.02
	cd ${S}; epatch ${FILESDIR}/${P}-prelink-lpthread.patch

	# Patch perldoc to not abort when it attempts to search
	# nonexistent directories; fixes bug #16589.
	# <rac@gentoo.org> (28 Feb 2003)

	cd ${S}; epatch ${FILESDIR}/${P}-perldoc-emptydirs.patch

	# this lays the groundwork for solving the issue of what happens
	# when people (or ebuilds) install different versiosn of modules
	# that are in the core, by rearranging the @INC directory to look
	# site -> vendor -> core.
	cd ${S}; epatch ${FILESDIR}/${P}-reorder-INC.patch

	# some well-intentioned stuff in http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&selm=Pine.SOL.4.10.10205231231200.5399-100000%40maxwell.phys.lafayette.edu
	# attempts to avoid bringing cccdlflags to bear on static
	# extensions (like DynaLoader).  i believe this is
	# counterproductive on a Gentoo system which has both a shared
	# and static libperl, so effectively revert this here.
	cd ${S}; epatch ${FILESDIR}/${P}-picdl.patch

	# uclibc support
	epatch ${FILESDIR}/perl-5.8.2-uclibc.patch

	# An additional tempfile patch, bug 75696
	#epatch ${FILESDIR}/file_path_rmtree.patch

	# Bug 80460, perlsuid vulnerability
	if use perlsuid
	then
		epatch ${FILESDIR}/CAN-2005-0156-suid.patch
	fi

}

src_compile() {
	# Perl has problems compiling with -Os in your flags with glibc
	use uclibc || replace-flags "-Os" "-O2"
	# This flag makes compiling crash in interesting ways
	filter-flags -malign-double

	export LC_ALL="C"
	local myconf=""

	if use ithreads
	then
		einfo "using ithreads"
		mythreading="-multi"
		myconf="-Dusethreads ${myconf}"
		myarch="${CHOST%%-*}-linux-thread"
	else
		myarch="${CHOST%%-*}-linux"
	fi

	if use gdbm
	then
		myconf="${myconf} -Di_gdbm"
	fi
	if use berkdb
	then
		myconf="${myconf} -Di_db"

		# ndbm.h is only provided by db1 (and perhaps by gdbm in
		# error). an alternate approach here would be to check for the
		# presence (or some string therein) of /usr/include/ndbm.h
		# itself.

		if has_version '=sys-libs/db-1*'
		then
			myconf="${myconf} -Di_ndbm"
		else
			myconf="${myconf} -Ui_ndbm"
		fi
	else
		myconf="${myconf} -Ui_db -Ui_ndbm"
	fi
	if use mips
	then
		# this is needed because gcc 3.3-compiled kernels will hang
		# the machine trying to run this test - check with `Kumba
		# <rac@gentoo.org> 2003.06.26
		myconf="${myconf} -Dd_u32align"
	fi

	if use debug
	then
		CFLAGS="${CFLAGS} -g"
	fi

	if use perlsuid
	then
		myconf="${myconf} -Dd_dosuid"
		ewarn "You have enabled Perl's suid compile. Please"
		ewarn "read http://perldoc.com/perl5.8.2/INSTALL.html#suidperl"
		epause 3
	fi

	if use sparc
	then
		myconf="${myconf} -Ud_longdbl"
	fi

	if use alpha && "$(gcc-getCC)" == "ccc"
	then
		ewarn "Perl will not be built with berkdb support, use gcc if you needed it..."
		myconf="${myconf} -Ui_db -Ui_ndbm"
	fi

	# These are temporary fixes. Need to edit the build so that that libraries created
	# only get compiled with -fPIC, since they get linked into shared objects, they
	# must be compiled with -fPIC.  Don't have time to parse through the build system
	# at this time.
	[ "${ARCH}" = "hppa" ] && append-flags -fPIC
#	[ "${ARCH}" = "amd64" ] && append-flags -fPIC

	sh Configure -des \
		-Darchname="${myarch}" \
		-Dcccdlflags='-fPIC' \
		-Dccdlflags='-rdynamic' \
		-Dcc="${CC:-gcc}" \
		-Dprefix='/usr' \
		-Dvendorprefix='/usr' \
		-Dsiteprefix='/usr' \
		-Dlocincpth=' ' \
		-Doptimize="${CFLAGS}" \
		-Duselargefiles \
		-Dd_semctl_semun \
		-Dscriptdir=/usr/bin \
		-Dman3ext='3pm' \
		-Dcf_by='Gentoo' \
		-Ud_csh \
		${myconf} || die "Unable to configure"

	MAKEOPTS="${MAKEOPTS} -j1" emake || die "Unable to make"

	emake -i test CCDLFLAGS=
}

src_install() {

	export LC_ALL="C"

	# Need to do this, else apps do not link to dynamic version of
	# the library ...
	local coredir="/usr/lib/perl5/${PV}/${myarch}${mythreading}/CORE"
	dodir ${coredir}
	dosym ../../../../${LIBPERL} ${coredir}/${LIBPERL}
	dosym ../../../../${LIBPERL} ${coredir}/libperl.so.${PERLSLOT}
	dosym ../../../../${LIBPERL} ${coredir}/libperl.so

	# Fix for "stupid" modules and programs
	dodir /usr/lib/perl5/site_perl/${PV}/${myarch}${mythreading}

	make DESTDIR="${D}" \
		INSTALLMAN1DIR="${D}/usr/share/man/man1" \
		INSTALLMAN3DIR="${D}/usr/share/man/man3" \
		install || die "Unable to make install"

	cp -f utils/h2ph utils/h2ph_patched
	epatch ${FILESDIR}/perl-5.8.0-RC2-special-h2ph-not-failing-on-machine_ansi_header.patch

	LD_LIBRARY_PATH=. ./perl -Ilib utils/h2ph_patched \
		-a -d ${D}/usr/lib/perl5/${PV}/${myarch}${mythreading} <<EOF
asm/termios.h
syscall.h
syslimits.h
syslog.h
sys/ioctl.h
sys/socket.h
sys/time.h
wait.h
EOF

	# This is to fix a missing c flag for backwards compat
	for i in `find ${D}/usr/lib/perl5 -iname "Config.pm"`;do
		sed -e "s:ccflags=':ccflags='-DPERL5 :" \
		    -e "s:cppflags=':cppflags='-DPERL5 :" \
			${i} > ${i}.new &&\
			mv ${i}.new ${i} || die "Sed failed"
	done

	# A poor fix for the miniperl issues
	dosed 's:./miniperl:/usr/bin/perl:' /usr/lib/perl5/${PV}/ExtUtils/xsubpp
	fperms 0444 /usr/lib/perl5/${PV}/ExtUtils/xsubpp
	dosed 's:./miniperl:/usr/bin/perl:' /usr/bin/xsubpp
	fperms 0755 /usr/bin/xsubpp

	./perl installman \
		--destdir="${D}" --man1ext='1' --man3ext='3'

	# This removes ${D} from Config.pm and .packlist
	for i in `find ${D} -iname "Config.pm"` `find ${D} -iname ".packlist"`;do
		einfo "Removing ${D} from ${i}..."
		sed -e "s:${D}::" ${i} > ${i}.new &&\
			mv ${i}.new ${i} || die "Sed failed"
	done

	dodoc Changes* Artistic Copying README Todo* AUTHORS

	if use doc
	then
		# HTML Documentation
		# We expect errors, warnings, and such with the following.

		dodir /usr/share/doc/${PF}/html
		./perl installhtml \
			--podroot='.' \
			--podpath='lib:ext:pod:vms' \
			--recurse \
			--htmldir="${D}/usr/share/doc/${PF}/html" \
			--libpods='perlfunc:perlguts:perlvar:perlrun:perlop'
	fi
	cd `find ${D} -name Path.pm|sed -e 's/Path.pm//'`
	# CAN patch in bug 79685
	epatch ${FILESDIR}/CAN-2005-0448-rmtree.patch
}

pkg_postinst() {

	# Make sure we do not have stale/invalid libperl.so 's ...
	if [ -f "${ROOT}usr/lib/libperl.so" -a ! -L "${ROOT}usr/lib/libperl.so" ]
	then
		mv -f ${ROOT}usr/lib/libperl.so ${ROOT}usr/lib/libperl.so.old
	fi

	local perllib="`readlink -f ${ROOT}usr/lib/libperl.so | sed -e 's:^.*/::'`"

	# If we are installing perl, we need the /usr/lib/libperl.so symlink to
	# point to the version of perl we are running, else builing something
	# against libperl.so will break ...
	if [ "${perllib}" != "${LIBPERL}" ]
	then
		# Delete stale symlinks
		rm -f ${ROOT}usr/lib/libperl.so
		rm -f ${ROOT}usr/lib/libperl.so.${PERLSLOT}
		# Regenerate libperl.so.${PERLSLOT}
		ln -snf ${LIBPERL} ${ROOT}usr/lib/libperl.so.${PERLSLOT}
		# Create libperl.so (we use the *soname* versioned lib here ..)
		ln -snf libperl.so.${PERLSLOT} ${ROOT}usr/lib/libperl.so
	fi

	INC=$(perl -e 'for $line (@INC) { next if $line eq "."; next if $line =~ m/'${PV}'|etc|local|perl$/; print "$line\n" }')
	if [ "${ROOT}" = "/" ]
	then
		ebegin "Removing old .ph files"
		for DIR in $INC; do
			if [ -d ${ROOT}/$DIR ]; then
				for file in $(find ${ROOT}/$DIR -name "*.ph" -type f); do
					rm ${ROOT}/$file
					einfo "<< $file"
				done
			fi
		done
		ebegin "Converting C header files to the corresponding Perl format"
		cd /usr/include;
		h2ph * sys/* arpa/* netinet/* bits/* security/* asm/* gnu/* linux/*
		cd /usr/include/linux;
		h2ph *

	fi


# This has been moved into a function because rumor has it that a future release
# of portage will allow us to check what version was just removed - which means
# we will be able to invoke this only as needed :)

	# Tried doing this via  -z, but $INC is too big...
	if [ "${INC}x" != "x" ]; then
		cleaner_msg
		epause 10
	fi

}

cleaner_msg() {
	eerror "You have changed versions of perl. It is recommended"
	eerror "that you run"
	eerror "dev-lang/perl/files/perl-cleaner "
	eerror "to assist with this transition. This script is capable"
	eerror "of cleaning out old .ph files, rebuilding modules for "
	eerror "your new version of perl, as well as re-emerging"
	eerror "applications that compiled against your old libperl.so"
	eerror
	eerror "PLEASE DO NOT INTERRUPT THE RUNNING OF THIS SCRIPT."
	eerror "Part of the rebuilding of applications compiled against "
	eerror "your old libperl involves temporarily unmerging"
	eerror "them - interruptions could leave you with unmerged"
	eerror "packages before they can be remerged."
	eerror ""
	eerror "If you have run the rebuilder and a package still gives"
	eerror "you trouble, and re-emerging it fails to correct"
	eerror "the problem, please check http://bugs.gentoo.org/"
	eerror "for more information or to report a bug."
	eerror ""
	eerror ""

}
