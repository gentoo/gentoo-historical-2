# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpgme/gpgme-0.4.0.ebuild,v 1.16 2004/05/31 20:34:34 vapier Exp $

DESCRIPTION="GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG easier for applications."
HOMEPAGE="http://www.gnupg.org/(en)/related_software/gpgme/index.html"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/alpha/gpgme/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0.4"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"
IUSE="nls crypt doc"

DEPEND=">=sys-libs/zlib-1.1.3
	>=app-crypt/gnupg-1.2*
	sys-apps/gawk
	sys-devel/libtool
	sys-devel/gcc"
RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv configure configure.orig
	sed	-e 's:^\(GPGME_CONFIG_LIBS\)=.*:\1="-lgpgme4":' \
		-e 's:^\(GPGME_CONFIG_CFLAGS\)=.*:\1="-I/usr/include/gpgme4":' \
		configure.orig > configure
	chmod +x configure

	cd ${S}
	for x in $(find . -name Makefile.in)
	do
		mv ${x} ${x}.orig
		sed	-e 's:libgpgme.la:libgpgme4.la:g' \
			${x}.orig > ${x}
	done
}

src_compile() {
	econf\
		$(use_enable nls) \
		$(use_enable crypt gpgmeplug) \
		$(use_enable doc maintainer-mode) || die "econf failed"
	emake || die
}

src_install() {
	make includedir="/usr/include/gpgme4" DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README README-alpha THANKS TODO VERSION

	mv ${D}/usr/bin/gpgme-config ${D}/usr/bin/gpgme4-config
	for x in $(find ${D}/usr/share/info -name gpgme.\*)
	do
		mv ${x} ${x/gpgme.info/gpgme4.info}
	done
}
