# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.8.5-r1.ebuild,v 1.6 2004/08/21 06:54:33 lv Exp $

inherit eutils

# OLD14 = 1.4
# OLD15 = 1.5
# OLD16 = 1.6
# OLD17 = 1.7
# NEW = 1.8 (.2)

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


# Currently this is 1.8, but it could change to 1.8.x as it
# does with 1.5d ... to determine this, install latest version
# of 1.8, and look at the generated files in the bin dir ..
# it should be something like (for 1.8.1):
#
# nosferatu automake-1.8.1 # ls /myinstallroot/bin/
# aclocal  aclocal-1.8  automake  automake-1.8
# nosferatu automake-1.8.1 #
#
# You should then set NEW_PV to 1.8, as this is the suffix
NEW_PV="1.8"

OLD17_PV="1.7.9"
OLD17_PV_S="1.7"
OLD17_P="${PN}-${OLD17_PV}"
OLD16_PV="1.6.3"
OLD16_PV_S="1.6"
OLD16_P="${PN}-${OLD16_PV}"
OLD15_PV="1.5"
OLD15_P="${PN}-${OLD15_PV}"
OLD14_PV="1.4-p6"
OLD14_P="${PN}-${OLD14_PV}"
OLD17_S="${WORKDIR}/${OLD17_P}"
OLD16_S="${WORKDIR}/${OLD16_P}"
OLD15_S="${WORKDIR}/${OLD15_P}"
OLD14_S="${WORKDIR}/${OLD14_P}"
DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="http://www.gnu.org/software/automake/automake.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2
	mirror://gnu/${PN}/${OLD17_P}.tar.bz2
	mirror://gnu/${PN}/${OLD16_P}.tar.bz2
	mirror://gnu/${PN}/${OLD15_P}.tar.gz
	mirror://gnu/${PN}/${OLD14_P}.tar.gz"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="x86 ~ppc ~sparc ~mips ~alpha arm hppa amd64 ~ia64 ~ppc64 ~s390"
IUSE="uclibc"

DEPEND="dev-lang/perl
	>=sys-devel/autoconf-2.58"

src_unpack() {
	unpack ${A}

	cd ${OLD15_S}
	epatch ${FILESDIR}/${PN}-${OLD15_PV}-target_hook.patch
	cd ${OLD17_S}
	epatch ${FILESDIR}/${PN}-${OLD17_PV}-infopage-namechange.patch
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.8.2-infopage-namechange.patch
	epatch ${FILESDIR}/${PN}-1.8.5-config-guess-uclibc.patch
}

src_compile() {
	#
	# ************ automake-1.8x ************
	#

	# stupid configure script goes and run autoconf in a subdir,
	# so 'ac-wrapper.pl' do not detect that it should use
	# autoconf-2.5x
	export WANT_AUTOCONF_2_5=1

	cd ${S}

	perl -pi -e 's:setfilename automake.info:setfilename automake18.info:' \
		doc/automake.texi
	perl -pi -e 's|\* automake: \(automake\)|\* Automake v1\.8: \(automake\)|' \
		doc/automake.texi
	perl -pi -e 's|\* aclocal:|\* aclocal v1.8:|' doc/automake.texi
	perl -pi -e 's:\(automake\):\(automake18\):' doc/automake.texi

	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} \
		|| die "configure 1.8x failed"
	emake || die "emake 1.8x failed"

	#
	# ************ automake-1.7x ************
	#

	# stupid configure script goes and run autoconf in a subdir,
	# so 'ac-wrapper.pl' do not detect that it should use
	# autoconf-2.5x
	export WANT_AUTOCONF_2_5=1

	cd ${OLD17_S}

	perl -pi -e 's:setfilename automake.info:setfilename automake17.info:' \
		automake.texi
	perl -pi -e 's|\* automake: \(automake\)|\* Automake v1\.7: \(automake\)|' \
		automake.texi
	perl -pi -e 's|\* aclocal:|\* aclocal v1.7:|' automake.texi
	perl -pi -e 's:\(automake\):\(automake17\):' automake.texi

	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} \
		|| die "configure 1.7x failed"
	emake || die "emake 1.7x failed"

	#
	# ************ automake-1.6x ************
	#

	# stupid configure script goes and run autoconf in a subdir,
	# so 'ac-wrapper.pl' do not detect that it should use
	# autoconf-2.5x
	export WANT_AUTOCONF_2_5=1

	cd ${OLD16_S}

	perl -pi -e 's:setfilename automake.info:setfilename automake16.info:' \
		automake.texi
	perl -pi -e 's|\* automake: \(automake\)|\* Automake v1\.6: \(automake\)|' \
		automake.texi
	perl -pi -e 's|\* aclocal:|\* aclocal v1.6:|' automake.texi
	perl -pi -e 's:\(automake\):\(automake16\):' automake.texi

	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} \
		|| die "configure 1.6x failed"
	emake || die "emake 1.6x failed"

	#
	# ************ automake-1.5x ************
	#

	cd ${OLD15_S}

	perl -pi -e 's:setfilename automake.info:setfilename automake15.info:' \
		automake.texi
	perl -pi -e 's|\* automake: \(automake\)|\* Automake v1\.5: \(automake\)|' \
		automake.texi
	perl -pi -e 's|\* aclocal:|\* aclocal v1.5:|' automake.texi
	perl -pi -e 's:\(automake\):\(automake15\):' automake.texi

	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} \
		|| die "configure 1.5x failed"
	emake || die "emake 1.5x failed"
	unset WANT_AUTOCONF_2_5

	#
	# ************ automake-1.4-p6 ************
	#
	cd ${OLD14_S}

	perl -pi -e 's|\* automake: \(automake\)|\* Automake v1\.4: \(automake\)|' \
		automake.texi
	perl -pi -e 's|\* aclocal:|\* aclocal v1.4:|' automake.texi
	perl -pi -e 's:GNU admin:GNU programming tools:' automake.texi
#	perl -pi -e 's|\* automake: \(automake\)|\* Automake: \(automake\)|' \
#		automake.texi

	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} \
		|| die "configure 1.4 failed"
	emake || die "emake 1.4 failed"
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
	newexe ${FILESDIR}/am-wrapper.pl-1.8-v2 am-wrapper.pl
	# Name binaries to exact version, as they have limited support for
	# more than one version installs
	dosed "s:1\.8x:${NEW_PV}:g" /usr/lib/${PN}/am-wrapper.pl
	dosed "s:1\.7x:${OLD17_PV_S}:g" /usr/lib/${PN}/am-wrapper.pl
	dosed "s:1\.6x:${OLD16_PV_S}:g" /usr/lib/${PN}/am-wrapper.pl
	dosed "s:1\.5x:${OLD15_PV}:g" /usr/lib/${PN}/am-wrapper.pl

	#
	# ************ automake-1.8x ************
	#

	cd ${S}
# not needed for 1.8.2
#	fix_bins ${NEW_PV}

	make DESTDIR=${D} \
		install || die

	for x in automake aclocal
	do
#		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-${NEW_PV}
		rm -f ${D}/usr/bin/${x}
	done

	doinfo doc/automake18.info*

	docinto ${PV}
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog

	#
	# ************ automake-1.7x ************
	#

	cd ${OLD17_S}
# not needed for 1.7.8
#	fix_bins ${NEW_PV}

	make DESTDIR=${D} \
		install || die

	for x in automake aclocal
	do
#		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-${NEW_PV}
		rm -f ${D}/usr/bin/${x}
	done

	doinfo automake17.info*

	docinto ${OLD17_PV}
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog

	#
	# ************ automake-1.6x ************
	#

	cd ${OLD16_S}
# not needed for 1.6.3
#	fix_bins ${NEW_PV}

	make DESTDIR=${D} \
		install || die

	for x in automake aclocal
	do
#		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-${NEW_PV}
		rm -f ${D}/usr/bin/${x}
	done

	doinfo automake16.info*

	docinto ${OLD16_PV}
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

	doinfo automake15.info*

	docinto ${OLD15_PV}
	dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog

	#
	# ************ automake-1.4-p6 ************
	#

	cd ${OLD14_S}
# Not needed anymore for 1.4-p6
#	fix_bins "1.4"

	# Ignore duplicates like automake-1.5 and 1.6
	#epatch ${FILESDIR}/${PN}-1.4_p5-ignore-duplicates.patch

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
	keepdir /usr/share/aclocal

	# remove all config.guess and config.sub files replacing them
	# w/ a symlink to a specific gnuconfig version
	use uclibc && for x in $(find ${D}/usr/share -name config.guess -o -name config.sub) ; do
		rm -f ${x}; ln -sf ../gnuconfig/$(basename ${x}) ${x}
	done
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
	# !!! NOTE: I should really think about removing this lot !!!
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
	if [ -d ${OLD16_S}/m4 ] && [ -d ${ROOT}/usr/share/aclocal-${OLD16_PV_S} ]
	then
		for x in ${ROOT}/usr/share/aclocal-${OLD16_PV_S}/*.m4
		do
			if [ ! -f ${OLD16_S}/m4/${x##*/} ]
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
	if [ -d ${OLD17_S}/m4 ] && [ -d ${ROOT}/usr/share/aclocal-${OLD17_PV_S} ]
	then
		for x in ${ROOT}/usr/share/aclocal-${OLD17_PV_S}/*.m4
		do
			if [ ! -f ${OLD17_S}/m4/${x##*/} ]
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

	echo
	einfo "Please note that the 'WANT_AUTOMAKE_1_?=1' have changed to:"
	echo
	einfo "  WANT_AUTOMAKE=<required version>"
	echo
	einfo "For instance:  WANT_AUTOMAKE=1.6"
	echo
}
