# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sgml-common/sgml-common-0.6.3-r3.ebuild,v 1.4 2003/07/19 22:55:30 tester Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Base ISO character entities and utilities for SGML"
SRC_URI="ftp://ftp.kde.org/pub/kde/devel/docbook/SOURCES/${P}.tgz
	http://download.sourceforge.net/pub/mirrors/kde/devel/docbook/SOURCES/${P}.tgz"
HOMEPAGE="http://www.iso.ch/cate/3524030.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa amd64"
src_unpack() {

	unpack ${A}
	# We use a hacked version of install-catalog that supports the ROOT variable
	cp ${FILESDIR}/${P}-install-catalog.in ${S}/bin
}

src_compile() {
	./configure	\
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man || die

	emake || die
}

src_install () {
	make \
		prefix=${D}/usr	\
		sysconfdir=${D}/etc	\
		mandir=${D}/usr/share/man \
		docdir=${D}/usr/share/doc \
		install || die

}

pkg_postinst() {
	if [ -x  "/usr/bin/install-catalog" ] && [ "$ROOT" = "/" ]
	then
		einfo "Installing Catalogs..."
		install-catalog --add \
			/etc/sgml/sgml-ent.cat \
			/usr/share/sgml/sgml-iso-entities-8879.1986/catalog

		install-catalog --add \
			/etc/sgml/sgml-docbook.cat \
			/etc/sgml/sgml-ent.cat
	else
		ewarn "install-catalog not found! Something went wrong!"
		die
	fi
}

pkg_prerm() {
	cp /usr/bin/install-catalog ${T}
}

pkg_postrm() {
	if [ ! -x  "/usr/bin/install-catalog" ] && [ "$ROOT" = "/" ]
	then
		einfo "Removing Catalogs..."
		if [ -e /etc/sgml/sgml-ent.cat ]
		then
		${T}/install-catalog --remove \
			/etc/sgml/sgml-ent.cat \
			/usr/share/sgml/sgml-iso-entities-8879.1986/catalog
		fi
	
		if [ -e /etc/sgml/sgml-docbook.cat ]
		then
		${T}/install-catalog --remove \
			/etc/sgml/sgml-docbook.cat \
			/etc/sgml/sgml-ent.cat
		fi
	fi
}

