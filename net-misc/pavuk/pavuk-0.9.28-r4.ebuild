# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pavuk/pavuk-0.9.28-r4.ebuild,v 1.1 2004/08/17 11:41:42 dsd Exp $

inherit eutils

IUSE="ssl X gtk gnome mozilla socks5 nls"

S="${WORKDIR}/${PN}-0.9pl28"
DESCRIPTION="Web spider and website mirroring tool"
HOMEPAGE="http://www.pavuk.org/"
SRC_URI="http://www.pavuk.org/sw/${PN}-0.9pl28.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND=">=sys-apps/sed-4.0.5
	sys-devel/gettext
	sys-libs/zlib
	ssl? ( dev-libs/openssl )
	X? ( virtual/x11 )
	gtk? ( =x11-libs/gtk+-1.2* )
	gnome? ( <gnome-base/gnome-panel-1.5 )
	mozilla? ( net-www/mozilla )
	socks5? ( net-misc/tsocks )"

src_unpack() {
	unpack ${A}

	# When pavuk connects to a web server and the server sends back
	# the HTTP status code 305 (Use Proxy), pavuk copies data from
	# the HTTP Location header in an unsafe manner. This leads to a
	# stack-based buffer overflow with control over EIP.
	EPATCH_OPTS="${EPATCH_OPTS} -d ${S}/src" \
		epatch ${FILESDIR}/pavuk-0.9.28-http.patch

	# more flaws.
	EPATCH_OPTS="${EPATCH_OPTS} -d ${S}/src" \
		epatch ${FILESDIR}/${PN}-0.9.28-digest_auth.c.patch
}

src_compile() {
	EXTRA_ECONF="--enable-threads --with-regex=auto" \
		econf \
		$(use_with X x) \
		$(use_enable ssl) \
		$(use_enable gtk) \
		$(use_enable gnome) \
		$(use_enable mozilla js) \
		$(use_enable socks5 socks) \
		$(use_enable nls) \
		|| die "econf failed"

	emake || die
}

src_install() {
	# fix sandbox violation for gnome .desktop and icon, and gnome menu entry
	if use gnome
	then
		sed -i 's:GNOME_PREFIX = /usr:GNOME_PREFIX = ${D}usr:' Makefile
		sed -i 's:GNOME_PREFIX = /usr:GNOME_PREFIX = ${D}usr:' icons/Makefile
		sed -i 's:Type=Internet:Type=Application:' pavuk.desktop
	fi

	einstall || die

	dodoc ABOUT-NLS README CREDITS FAQ NEWS AUTHORS COPYING BUGS \
		TODO MAILINGLIST ChangeLog wget-pavuk.HOWTO jsbind.txt \
		pavuk_authinfo.sample  pavukrc.sample
}
