# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-mail/balsa/balsa-2.0.3.ebuild,v 1.1 2002/12/13 01:36:29 foser Exp $

inherit debug gnome2 eutils

S=${WORKDIR}/${P}

DESCRIPTION="Balsa: Technical Preview email client for GNOME"
SRC_URI="http://balsa.gnome.org/${P}.tar.bz2"
HOMEPAGE="http://balsa.gnome.org"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~sparc64"

RDEPEND="net-mail/mailbase
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=net-libs/libesmtp-0.8.11
	>=app-text/aspell-0.50
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-vfs-2
	=gnome-base/libgnomeprint-1*
	=gnome-base/libgnomeprintui-1*
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl )
	perl? ( >=dev-libs/libpcre-3.4 )
	gtkhtml? ( >=gnome-extra/libgtkhtml-2 )
	ldap? ( net-nds/openldap )"

DEPEND="dev-util/pkgconfig
	>=app-text/scrollkeeper-0.1.4
	${RDEPEND}"

src_unpack() {
	unpack ${A}

	# this patch is from Riccardo Persichetti
	# (ricpersi@libero.it) to make balsa compile
	# <seemant@gentoo.org> this patch is updated by me to compile
	# against the new aspell (until upstream gets its act together, aspell
	# will be a required dep).
	epatch ${FILESDIR}/${P}-aspell-configure.patch

	# and get our patch in
	cd ${S}
	autoconf || die
}

src_compile() {
	local myconf
	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"
	use ssl \
		&& myconf="${myconf} --with-ssl" \
		|| myconf="${myconf} --without-ssl" 
	use gtkhtml \
		&& myconf="${myconf} --with-gtkhtml" \
		|| myconf="${myconf} --without-gtkhtml"
	use perl \
		&& myconf="${myconf} --enable-pcre" \
		|| myconf="${myconf} --disable-pcre"

#	use spell \
#		&& myconf="${myconf} --with-aspell" \
#		|| myconf="${myconf} --without-aspell --without-spell"

#	aspell is not optional atm
	myconf="${myconf} --with-aspell"

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
