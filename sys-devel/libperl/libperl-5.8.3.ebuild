# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/libperl/libperl-5.8.3.ebuild,v 1.6 2004/06/15 03:27:17 agriffis Exp $

# The basic theory based on comments from Daniel Robbins <drobbins@gentoo.org>.
#
# We split the perl ebuild into libperl and perl.  The layout is as follows:
#
# libperl:
#
#  This is a slotted (SLOT=[0-9]*) ebuild, meaning we should be able to have a
#  few versions that are not binary compadible installed.
#
#  How we get libperl.so multi-versioned, is by adding to the link command:
#
#    -Wl,-soname -Wl,libperl.so.`echo $(LIBPERL) | cut -d. -f3`
#
#  This gives us:
#
#    $(LIBPERL): $& perl$(OBJ_EXT) $(obj) $(LIBPERLEXPORT)
#        $(LD) -o $@ $(SHRPLDFLAGS) perl$(OBJ_EXT) $(obj) \
#              -Wl,-soname -Wl,libperl.so.`echo $(LIBPERL) | cut -d. -f3`
#
#  We then configure perl with LIBPERL set to:
#
#    LIBPERL="libperl.so.${SLOT}.`echo ${PV} | cut -d. -f1,2`"
#
#  Or with the variables defined in this ebuild:
#
#    LIBPERL="libperl.so.${PERLSLOT}.${SHORT_PV}"
#
#  The result is that our 'soname' is 'libperl.so.${PERLSLOT}' (at the time of
#  writing this for perl-5.8.0, 'libperl.so.1'), causing all apps that is linked
#  to libperl to link to 'libperl.so.${PERLSLOT}'.
#
#  If a new perl version, perl-z.y.z comes out that have a libperl not binary
#  compatible with the previous version, we just keep the previous libperl
#  installed, and all apps linked to it will still be able to use:
#
#    libperl.so.${PERLSLOT}'
#
#  while the new ones will link to:
#
#    libperl.so.$((PERLSLOT+1))'
#
# perl:
#
#  Not much to this one.  It compiles with a static libperl.a, and are unslotted
#  (meaning SLOT=0).  We thus always have the latest *stable* perl version
#  installed, with corrisponding version of libperl.  The perl ebuild will of
#  course DEPEND on libperl.
#
# Martin Schlemmer <azarah@gentoo.org> (28 Dec 2002).


IUSE="berkdb gdbm threads"

inherit eutils flag-o-matic

# Perl has problems compiling with -Os in your flags
replace-flags "-Os" "-O2"
# This flag makes compiling crash in interesting ways
filter-flags "-malign-double"

# The slot of this binary compat version of libperl.so
PERLSLOT="1"

SHORT_PV="`echo ${PV} | cut -d. -f1,2`"
MY_P="perl-`echo $PV | sed 's/_rc/-RC/'`"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Larry Wall's Practical Extraction and Reporting Language"
SRC_URI="ftp://ftp.cpan.org/pub/CPAN/src/${MY_P}.tar.gz"
HOMEPAGE="http://www.perl.org"

if [ "${PN}" = "libperl" ]
then
	SLOT="${PERLSLOT}"
else
	SLOT="0"
fi

LIBPERL="libperl.so.${PERLSLOT}.${SHORT_PV}"

LICENSE="Artistic GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha arm ~hppa ~amd64 ~ia64 ~ppc64 s390"

DEPEND="sys-apps/groff
	berkdb? ( sys-libs/db )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	>=sys-apps/portage-2.0.45-r4"

RDEPEND="
	berkdb? ( sys-libs/db )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )"

PDEPEND=">=dev-lang/perl-${PV}"

pkg_setup() {
	# I think this should rather be displayed if you *have* 'threads'
	# in USE if it could break things ...
	if use threads
	then
		ewarn ""
		ewarn "PLEASE NOTE: You are compiling perl-5.8 with"
		ewarn "threading enabled."
		ewarn "Threading is not supported by all applications "
		ewarn "that compile against perl. You use threading at "
		ewarn "your own discretion. "
		ewarn ""
		sleep 10
	else
		ewarn ""
		ewarn "PLEASE NOTE: If you want to compile perl-5.8 with"
		ewarn "threading enabled , you must restart this emerge"
		ewarn "with USE=threads emerge...."
		ewarn "Threading is not supported by all applications "
		ewarn "that compile against perl. You use threading at "
		ewarn "your own discretion. "
		ewarn ""
		sleep 10
	fi
}

src_unpack() {

	unpack ${A}

	# Fix the build scripts to create libperl with a soname of ${SLOT}.
	# We basically add:
	#
	#   -Wl,-soname -Wl,libperl.so.`echo $(LIBPERL) | cut -d. -f3`
	#
	# to the line that links libperl.so, and then set LIBPERL to:
	#
	#   LIBPERL=libperl.so.${SLOT}.`echo ${PV} | cut -d. -f1,2`
	#
	cd ${S}; epatch ${FILESDIR}/${P}-create-libperl-soname.patch
}

src_compile() {

	export LC_ALL="C"
	local myconf=""

	if use threads
	then
		einfo "using threads"
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
		myconf="${myconf} -Di_db -Di_ndbm"
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
	if use sparc
	then
		myconf="${myconf} -Ud_longdbl"
	fi
	if use sparc64
	then
		myconf="${myconf} -Ud_longdbl"
	fi

	if [ "${PN}" = "libperl" ]
	then
		rm -f config.sh Policy.sh

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
			-Duseshrplib \
			-Dman3ext='3pm' \
			-Dlibperl="${LIBPERL}" \
			-Dd_dosuid \
			-Dd_semctl_semun \
			-Dcf_by='Gentoo' \
			-Ud_csh \
			${myconf} || die

		emake -f Makefile depend || die "Couldn't make libperl.so depends"
		emake -f Makefile ${LIBPERL} || die "Unable to make libperl.so"
		mv ${LIBPERL} ${WORKDIR}
	else
cat > config.over <<EOF
installprefix=${D}/usr
installarchlib=\`echo \$installarchlib | sed "s!\$prefix!\$installprefix!"\`
installbin=\`echo \$installbin | sed "s!\$prefix!\$installprefix!"\`
installman1dir=\`echo \$installman1dir | sed "s!\$prefix!\$installprefix!"\`
installman3dir=\`echo \$installman3dir | sed "s!\$prefix!\$installprefix!"\`
installman1dir=\`echo \$installman1dir | sed "s!/share/share/!/share/!"\`
installman3dir=\`echo \$installman3dir | sed "s!/share/share/!/share/!"\`
installman1dir=\`echo \$installman1dir | sed "s!/usr/man/!/usr/share/man/!"\`
installman3dir=\`echo \$installman3dir | sed "s!/usr/man/!/usr/share/man/!"\`
man1ext=1
man3ext=3pm
installprivlib=\`echo \$installprivlib | sed "s!\$prefix!\$installprefix!"\`
installscript=\`echo \$installscript | sed "s!\$prefix!\$installprefix!"\`
installsitelib=\`echo \$installsitelib | sed "s!\$prefix!\$installprefix!"\`
installsitearch=\`echo \$installsitearch | sed "s!\$prefix!\$installprefix!"\`
EOF
sleep 10
		sh Configure -des \
			-Darchname="${myarch}" \
			-Dcc="${CC:-gcc}" \
			-Dprefix='/usr' \
			-Dvendorprefix='/usr' \
			-Dsiteprefix='/usr' \
			-Dlocincpth=' ' \
			-Doptimize="${CFLAGS}" \
			-Duselargefiles \
			-Dd_dosuid \
			-Dd_semctl_semun \
			-Dscriptdir=/usr/bin \
			-Dman3ext='3pm' \
			-Dcf_by='Gentoo' \
			-Ud_csh \
			${myconf} || die "Unable to configure"

		MAKEOPTS="${MAKEOPTS} -j1" emake || die "Unable to make"

		emake -i test CCDLFLAGS=
	fi
}

src_install() {

	export LC_ALL="C"

	if [ "${PN}" = "libperl" ]
	then
		dolib.so ${WORKDIR}/${LIBPERL}
		preplib
	else
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
			--man1dir="${D}/usr/share/man/man1" --man1ext='1' \
			--man3dir="${D}/usr/share/man/man3" --man3ext='3'

		# This removes ${D} from Config.pm and .packlist
		for i in `find ${D} -iname "Config.pm"` `find ${D} -iname ".packlist"`;do
			einfo "Removing ${D} from ${i}..."
			sed -e "s:${D}::" ${i} > ${i}.new &&\
				mv ${i}.new ${i} || die "Sed failed"
		done
	fi

	dodoc Changes* Artistic Copying README Todo* AUTHORS

	if [ "${PN}" = "perl" ]
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
}

pkg_postinst() {

	# Make sure we do not have stale/invalid libperl.so 's ...
	if [ -f "${ROOT}usr/lib/libperl.so" -a ! -L "${ROOT}usr/lib/libperl.so" ]
	then
		mv -f ${ROOT}usr/lib/libperl.so ${ROOT}usr/lib/libperl.so.old
	fi

	# Next bit is to try and setup the /usr/lib/libperl.so symlink
	# properly ...
	local libnumber="`ls -1 ${ROOT}usr/lib/libperl.so.?.* | grep -v '\.old' | wc -l`"
	if [ "${libnumber}" -eq 1 ]
	then
		# Only this version of libperl is installed, so just link libperl.so
		# to the *soname* version of it ...
		ln -snf libperl.so.${PERLSLOT} ${ROOT}usr/lib/libperl.so
	else
		if [ -x "${ROOT}/usr/bin/perl" ]
		then
			# OK, we have more than one version .. first try to figure out
			# if there are already a perl installed, if so, link libperl.so
			# to that *soname* version of libperl.so ...
			local perlversion="`${ROOT}/usr/bin/perl -V:version | cut -d\' -f2 | cut -d. -f1,2`"

			cd ${ROOT}usr/lib
			# Link libperl.so to the *soname* versioned lib ...
			ln -snf `echo libperl.so.?.${perlversion} | cut -d. -f1,2,3` libperl.so
		else
			local x latest

			# Nope, we are not so lucky ... try to figure out what version
			# is the latest, and keep fingers crossed ...
			for x in `ls -1 ${ROOT}usr/lib/libperl.so.?.*`
			do
				latest="${x}"
			done

			cd ${ROOT}usr/lib
			# Link libperl.so to the *soname* versioned lib ...
			ln -snf `echo ${latest##*/} | cut -d. -f1,2,3` libperl.so
		fi
	fi
}


