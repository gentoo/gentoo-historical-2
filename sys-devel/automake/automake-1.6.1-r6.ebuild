# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# /space/gentoo/cvsroot/gentoo-x86/sys-devel/automake/automake-1.6.1.ebuild,v 1.4 2002/04/23 19:42:16 azarah Exp

# OLD14 = 1.4
# OLD15 = 1.5
# NEW = 1.6 (.1)

# NOTE:  For all of those brave souls out there that wants to fix
#        or update this, note that all three versions install
#        .m4 files to /usr/share/aclocal-${ver}/ and .am files
#        to /usr/share/automake-${ver}/.  We then add the default
#        /usr/share/aclocal/ to aclocal's search path by adding
#        "push (@dirlist, \"/usr/share/aclocal\");" after @dirlist
#        is defined the first time (done in fix_bins() function).
#
#        The theory thus is, all version specific data goes into
#        version specific directories, but programs like ogg/whatever
#        can still install thier .m4 macros into /usr/share/aclocal/.
#
#        Martin Schlemmer <azarah@gentoo.org>
#        19 May 2002


# Currently this is 1.6, but it could change to 1.6.x as it
# does with 1.5d ... to determine this, install latest version
# of 1.6, and look at the generated files in the bin dir ..
# it should be something like (for 1.6.1):
#
# nosferatu automake-1.6.1 # ls /myinstallroot/bin/
# aclocal  aclocal-1.6  automake  automake-1.6
# nosferatu automake-1.6.1 #
#
# You should then set NEW_PV to 1.6, as this is the suffix
NEW_PV=1.6

OLD15_PV=1.5
OLD15_P=${PN}-${OLD15_PV}
OLD14_PV=1.4-p5
OLD14_P=${PN}-${OLD14_PV}
S=${WORKDIR}/${P}
OLD15_S=${WORKDIR}/${OLD15_P}
OLD14_S=${WORKDIR}/${OLD14_P}
DESCRIPTION="Used to generate Makefile.in from Makefile.am"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz
	ftp://ftp.gnu.org/gnu/${PN}/${OLD15_P}.tar.gz
	ftp://ftp.gnu.org/gnu/${PN}/${OLD14_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/automake/automake.html"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha arm"

DEPEND="sys-devel/perl
	>=sys-devel/autoconf-2.53-r1"

SLOT="1.5"


src_unpack() {

	unpack ${A}

	cd ${OLD15_S}
	patch -p1 <${FILESDIR}/${PN}-${OLD15_PV}-target_hook.patch || die
}

src_compile() {

	#
	# ************ automake-1.6x ************
	#

	# stupid configure script goes and run autoconf in a subdir,
	# so 'ac-wrapper.pl' do not detect that it should use
	# autoconf-2.5x
	export WANT_AUTOCONF_2_5=1
	
	cd ${S}

	perl -pi -e "s:setfilename automake.info:setfilename automake-1.6.info:" \
		automake.texi
	
	./configure --prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} || die
	
	emake ${MAKEOPTS} || die

	#
	# ************ automake-1.5x ************
	#

	cd ${OLD15_S}

	perl -pi -e "s:setfilename automake.info:setfilename automake-1.5.info:" \
		automake.texi
	
	./configure --prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} || die
	
	emake ${MAKEOPTS} || die
	unset WANT_AUTOCONF_2_5

	#
	# ************ automake-1.4-p5 ************
	#
	cd ${OLD14_S}
	./configure --prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} || die
		
	emake ${MAKEOPTS} || die
}

# This basically fix aclocal and automake so that they
# use the correct directories, and also adds the normal
# /usr/share/aclocal for aclocal to include.
fix_bins() {
	
	for x in aclocal automake
	do
		perl -pi -e "s:share/automake\":share/automake-${1}\":g" ${x}
		perl -pi -e "s:share/aclocal\":share/aclocal-${1}\":g" ${x}
	done
	
	# add "/usr/share/aclocal" to m4 search patch
	cp aclocal aclocal.orig
	sed -e '/&scan_m4_files (@dirlist);/i \push (@dirlist, \"/usr/share/aclocal\");' \
		aclocal.orig > aclocal
	# same as above, but 1.4 looks a bit differently
	cp aclocal aclocal.orig
	sed -e '/&scan_m4_files ($acdir, @dirlist);/i \push (@dirlist, \"/usr/share/aclocal\");' \
		aclocal.orig > aclocal
	# "aclocal --print-ac-dir" should return "/usr/share/aclocal"
	cp aclocal aclocal.orig
	sed -e 's:print $acdir:print "/usr/share/aclocal":' \
		aclocal.orig > aclocal
}

src_install() {

	# install wrapper script for autodetecting the proper version
	# to use.
	exeinto /usr/lib/${PN}
	newexe ${FILESDIR}/am-wrapper.pl-1.6 am-wrapper.pl
	# Name binaries to exact version, as they have limited support for
	# more than one version installs
	dosed "s:1\.6x:${NEW_PV}:g" /usr/lib/${PN}/am-wrapper.pl
	dosed "s:1\.5x:${OLD15_PV}:g" /usr/lib/${PN}/am-wrapper.pl

	#
	# ************ automake-1.6x ************
	#

	cd ${S}
# not needed for 1.6.1
#	fix_bins ${NEW_PV}
	
	make DESTDIR=${D} \
		install || die

	for x in automake aclocal
	do
#		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-${NEW_PV}
		rm -f ${D}/usr/bin/${x}
	done

	doinfo automake-1.6.info*

	docinto ${PV}
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog

	#
	# ************ automake-1.5x ************
	#

	cd ${OLD15_S}
	fix_bins ${OLD15_PV}
	
	make DESTDIR=${D} \
		pkgdatadir=/usr/share/automake-${OLD15_PV} \
		m4datadir=/usr/share/aclocal-${OLD15_PV} \
		install || die

	for x in automake aclocal
	do
		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-${OLD15_PV}
		rm -f ${D}/usr/bin/${x}
	done

	doinfo automake-1.5.info*

	docinto ${OLD15_PV}
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog

	#
	# ************ automake-1.4-p5 ************
	#

	cd ${OLD14_S}
	fix_bins "1.4"

	# Ignore duplicates like automake-1.5 and 1.6
	patch -p0 <${FILESDIR}/${PN}-1.4_p5-ignore-duplicates.patch || die
	
	make DESTDIR=${D} \
		pkgdatadir=/usr/share/automake-1.4 \
		m4datadir=/usr/share/aclocal-1.4 \
		install || die

	for x in automake aclocal
	do
		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-1.4
		dosym ../lib/${PN}/am-wrapper.pl /usr/bin/${x}
	done

	docinto ${OLD14_PV}
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog

	#
	# ************ misc stuff ****************
	
	# Some packages needs a /usr/share/automake directory
	dosym automake-1.4 /usr/share/automake

	# This is the default macro directory that apps use ..
	dodir /usr/share/aclocal
	touch ${D}/usr/share/aclocal/.keep
}

pkg_preinst() {
	
	# remove these to make sure symlinks install properly if old versions
	# was binaries
	for x in automake aclocal
	do
		if [ -e ${ROOT}/usr/bin/${x} ]
		then
			rm -f ${ROOT}/usr/bin/${x}
		fi
	done

	# nuke this if it is a directory, as the new one is a symlink
	if [ -d ${ROOT}/usr/share/automake ]
	then
		rm -rf ${ROOT}/usr/share/automake
	fi

	# Make sure we move all the macros not installed with automake
	# to the non version specific aclocal dir.
	if [ ! -d ${ROOT}/usr/share/aclocal ]
	then
		mkdir -p ${ROOT}/usr/share/aclocal
	fi
	if [ -d ${OLD14_S}/m4 ] && [ -d ${ROOT}/usr/share/aclocal-1.4 ]
	then
		for x in ${ROOT}/usr/share/aclocal-1.4/*.m4
		do
			if [ ! -f ${OLD14_S}/m4/${x##*/} ]
			then
				if [ ! -f ${ROOT}/usr/share/aclocal/${x##*/} ]
				then
					einfo "Moving ${x} to aclocal..."
					mv -f ${x} ${ROOT}/usr/share/aclocal
				else
					einfo "Deleting duplicate ${x}..."
					rm -f ${x}
				fi
			fi
		done
	fi
	if [ -d ${OLD15_S}/m4 ] && [ -d ${ROOT}/usr/share/aclocal-${OLD15_PV} ]
	then
		for x in ${ROOT}/usr/share/aclocal-${OLD15_PV}/*.m4
		do
			if [ ! -f ${OLD15_S}/m4/${x##*/} ]
			then
				if [ ! -f ${ROOT}/usr/share/aclocal/${x##*/} ]
				then
					einfo "Moving ${x} to aclocal..."
					mv -f ${x} ${ROOT}/usr/share/aclocal
				else
					einfo "Deleting duplicate ${x}..."
					rm -f ${x}
				fi
			fi
		done
	fi
	if [ -d ${S}/m4 ] && [ -d ${ROOT}/usr/share/aclocal-${NEW_PV} ]
	then
		for x in ${ROOT}/usr/share/aclocal-${NEW_PV}/*.m4
		do
			if [ ! -f ${S}/m4/${x##*/} ]
			then
				if [ ! -f ${ROOT}/usr/share/aclocal/${x##*/} ]
				then
					einfo "Moving ${x} to aclocal..."
					mv -f ${x} ${ROOT}/usr/share/aclocal
				else
					einfo "Deleting duplicate ${x}..."
					rm -f ${x}
				fi
			fi
		done
	fi
}

pkg_postinst() {

	# nuke duplicate macros
	for x in ${ROOT}/usr/share/aclocal-1.4/*.m4
	do
		if [ -f ${ROOT}/usr/share/aclocal/${x##*/} ]
		then
			rm -f ${ROOT}/usr/share/aclocal/${x##*/}
		fi
	done
}

