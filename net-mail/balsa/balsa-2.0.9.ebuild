# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-mail/balsa/balsa-2.0.9.ebuild,v 1.1 2003/03/03 20:23:21 foser Exp $

inherit gnome2 eutils

S=${WORKDIR}/${P}

IUSE="ssl gtkhtml perl ldap"
DESCRIPTION="Email client for GNOME"
SRC_URI="http://balsa.gnome.org/${P}.tar.bz2"
HOMEPAGE="http://balsa.gnome.org"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

RDEPEND="net-mail/mailbase
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=net-libs/libesmtp-0.8.11
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgnomeprint-2.1.4
	>=gnome-base/libgnomeprintui-2.1.4
	>=app-text/aspell-0.50
	ssl? ( dev-libs/openssl )
	perl? ( >=dev-libs/libpcre-3.4 )
	gtkhtml? ( >=gnome-extra/libgtkhtml-2 )
	ldap? ( net-nds/openldap )"

DEPEND="dev-util/pkgconfig
	sys-devel/gettext
	>=app-text/scrollkeeper-0.1.4
	${RDEPEND}"

src_compile() {
	local myconf
	use ssl \
		&& myconf="${myconf} --with-ssl" \
		|| myconf="${myconf} --without-ssl" 
	use gtkhtml \
		&& myconf="${myconf} --with-gtkhtml" \
		|| myconf="${myconf} --without-gtkhtml"
	use perl \
		&& myconf="${myconf} --enable-pcre" \
		|| myconf="${myconf} --disable-pcre"

	libmutt/configure \
		--prefix=/usr \
		--host=${CHOST} \
		--with-mailpath=/var/mail || die "configure libmutt failed"

	myconf="${myconf} --enable-threads"

	econf ${myconf} || die "configure balsa failed"
	emake || die "emake failed"
}

src_install () {
	local myinst
	myinst="gnomeconfdir=${D}/etc \
		gnomedatadir=${D}/usr/share"

	einstall ${myinst} || die "make install failed"
	dodoc AUTHORS COPYING ChangeLog HACKING INSTALL NEWS README TODO
	docinto docs
	dodoc docs/*
}
