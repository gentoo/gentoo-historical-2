# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autoconf/autoconf-2.52i.ebuild,v 1.1 2002/03/26 00:48:55 azarah Exp $

OLD_PV=2.13
OLD_P=${PN}-${OLD_PV}
S=${WORKDIR}/${P}
OLD_S=${WORKDIR}/${OLD_P}
DESCRIPTION="Used to create autoconfiguration files"
SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.bz2
	ftp://ftp.gnu.org/gnu/${PN}/${OLD_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/autoconf/autoconf.html"

DEPEND=">=sys-devel/m4-1.4p
	sys-devel/perl"

src_unpack() {

	unpack ${A}
	cd ${OLD_S}
	patch -p0 < ${FILESDIR}/${OLD_P}-configure-gentoo.diff || die
	patch -p0 < ${FILESDIR}/${OLD_P}-configure.in-gentoo.diff || die
}

src_compile() {

	#
	# ************ autoconf-2.5x ************
	#
	cd ${S}
	./configure --prefix=/usr \
		--datadir=/usr/share/${P} \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} || die
	
	emake || die

	#
	# ************ autoconf-2.13 ************
	#
	cd ${OLD_S}
	./configure --prefix=/usr \
		--datadir=/usr/share/${OLD_P} \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--target=${CHOST} || die
		
	emake || die
}

src_install() {

	# install wrapper script for autodetecting the proper version
	# to use.
	exeinto /usr/lib/${PN}
	doexe ${FILESDIR}/ac-wrapper.pl

	#
	# ************ autoconf-2.5x ************
	#

	# need to use 'DESTDIR' here, else perl stuff puke
	cd ${S}
	make DESTDIR=${D} \
		datadir=/usr/share/${P} \
		install || die

	for x in autoconf autoheader autoreconf autoscan autoupdate ifnames autom4te
	do
		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-2.5x
	done
	# new in 2.5x
	dosym ../lib/${PN}/ac-wrapper.pl /usr/bin/autom4te

	mv ${D}/usr/share/info/autoconf.info ${D}/usr/share/info/autoconf-2.5.info

	docinto ${PF}/${PV}
	dodoc COPYING AUTHORS BUGS NEWS README TODO THANKS
	dodoc ChangeLog ChangeLog.0 ChangeLog.1 ChangeLog.2

	#
	# ************ autoconf-2.13 ************
	#

	# need to use 'prefix' here, else we get sandbox problems
    cd ${OLD_S}
	make prefix=${D}/usr \
		datadir=${D}/usr/share/${OLD_P} \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die

	for x in autoconf autoheader autoreconf autoscan autoupdate ifnames
	do
		mv ${D}/usr/bin/${x} ${D}/usr/bin/${x}-${OLD_PV}
		dosym ../lib/${PN}/ac-wrapper.pl /usr/bin/${x}
	done

	docinto ${PF}/${OLD_PV}
	dodoc COPYING AUTHORS NEWS README TODO
	dodoc ChangeLog ChangeLog.0 ChangeLog.1

	# from binutils
	rm -f ${D}/usr/share/info/standards.info*
}

pkg_preinst() {
	
	# remove these to make sure symlinks install properly if old versions
	# was binaries
	for x in autoconf autoheader autoreconf autoscan autoupdate ifnames autom4te
	do
		if [ -e /usr/bin/${x} ]
		then
			rm -f /usr/bin/${x}
		fi
	done
}

