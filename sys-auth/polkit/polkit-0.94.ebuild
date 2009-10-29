# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit/polkit-0.94.ebuild,v 1.1 2009/10/29 23:28:01 eva Exp $

EAPI="2"

inherit autotools eutils multilib pam

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="http://hal.freedesktop.org/docs/PolicyKit"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc expat pam zsh-completion nls"
# introspection

# not mature enough
#	introspection? ( dev-libs/gobject-introspection )
RDEPEND=">=dev-libs/glib-2.21.4
	>=dev-libs/eggdbus-0.5
	expat? ( dev-libs/expat )
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	!!>=sys-auth/policykit-0.92
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	>=dev-util/pkgconfig-0.18
	>=dev-util/intltool-0.36
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.10 )"

pkg_setup() {
	enewgroup polkituser
	enewuser polkituser -1 "-1" /dev/null polkituser
}

src_prepare() {
	# Add zsh completions
	if use zsh-completion; then
		epatch "${FILESDIR}/${PN}-0.92-zsh-completions.patch"
	fi

	# Fix daemon binary collision with <=policykit-0.9, fdo bug 22951
	epatch "${FILESDIR}/${PN}-0.93-fix-daemon-name.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_configure() {
	local conf

	if use pam ; then
		conf="--with-authfw=pam --with-pam-module-dir=$(getpam_mod_dir)"
	else
		conf="--with-authfw=none"
	fi

	if use expat; then
		conf="--with-expat=/usr"
	fi

	econf ${conf} \
		--disable-introspection \
		--disable-ansi \
		--enable-fast-install \
		--enable-libtool-lock \
		--enable-man-pages \
		--disable-dependency-tracking \
		--with-os-type=gentoo \
		--with-polkit-user=polkituser \
		--localstatedir=/var \
		$(use_enable debug verbose-mode) \
		$(use_enable doc gtk-doc) \
		$(use_enable nls)
		#$(use_enable introspection)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc NEWS README AUTHORS ChangeLog || die "dodoc failed"

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins "${S}/tools/_polkit" || die "zsh completion died"
		doins "${S}/tools/_polkit_auth" || die "zsh completion died"
		doins "${S}/tools/_polkit_action" || die "zsh completion died"
	fi

	# Need to keep a few directories around...
	diropts -m0700 -o root -g polkituser
	keepdir /var/run/polkit-1
	keepdir /var/lib/polkit-1
}
