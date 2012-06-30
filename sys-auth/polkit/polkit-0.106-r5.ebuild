# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit/polkit-0.106-r5.ebuild,v 1.4 2012/06/30 10:27:11 swift Exp $

EAPI=4
inherit eutils multilib pam pax-utils systemd user

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/polkit"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug examples gtk +introspection kde nls pam selinux systemd"

RDEPEND=">=dev-lang/spidermonkey-1.8.5
	>=dev-libs/glib-2.32
	>=dev-libs/expat-2
	introspection? ( >=dev-libs/gobject-introspection-1 )
	pam? (
		sys-auth/pambase
		virtual/pam
		)
	selinux? ( sec-policy/selinux-policykit )
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/intltool
	virtual/pkgconfig"
PDEPEND="
	gtk? ( || (
		>=gnome-extra/polkit-gnome-0.105
		lxde-base/lxpolkit
		) )
	kde? ( sys-auth/polkit-kde-agent )
	pam? (
		systemd? ( sys-auth/pambase[systemd] )
		!systemd? ( sys-auth/pambase[consolekit] )
		)
	!systemd? ( >=sys-auth/consolekit-0.4.5_p2012[policykit] )"

pkg_setup() {
	local u=polkitd
	local g=polkitd
	local h=/var/lib/polkit-1

	enewgroup ${g}
	enewuser ${u} -1 -1 ${h} ${g}
	esethome ${u} ${h}
}

src_prepare() {
	sed -i -e 's|unix-group:wheel|unix-user:0|' src/polkitbackend/*-default.rules || die #401513
	has_version ">=dev-lang/spidermonkey-1.8.7" && { sed -i -e '/mozjs/s:185:187:g' configure || die; }
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		$(use_enable debug verbose-mode) \
		--enable-man-pages \
		--disable-gtk-doc \
		$(use_enable systemd libsystemd-login) \
		$(use_enable introspection) \
		--disable-examples \
		$(use_enable nls) \
		"$(systemd_with_unitdir)" \
		--with-authfw=$(usex pam pam shadow) \
		$(use pam && echo --with-pam-module-dir="$(getpam_mod_dir)") \
		--with-os-type=gentoo
}

src_install() {
	emake \
		DESTDIR="${D}" \
		libprivdir="${EPREFIX}"/usr/$(get_libdir)/polkit-1 \
		install

	dodoc docs/TODO HACKING NEWS README

	fowners -R polkitd:root /{etc,usr/share}/polkit-1/rules.d

	diropts -m0700 -o polkitd -g polkitd
	keepdir /var/lib/polkit-1

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/examples/{*.c,*.policy*}
	fi

	prune_libtool_files
	rm -f "${ED}"/usr/lib*/pkgconfig/polkit-backend-1.pc #423431

	# Required for polkitd on hardened/PaX due to spidermonkey's JIT
	if has_version '<dev-lang/spidermonkey-1.8.7'; then
		pax-mark mr "${ED}"/usr/$(get_libdir)/polkit-1/polkitd
	elif has_version '>=dev-lang/spidermonkey-1.8.7[jit]'; then
		pax-mark m "${ED}"/usr/$(get_libdir)/polkit-1/polkitd
	fi
}

pkg_postinst() {
	chown -R polkitd:root "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	chown -R polkitd:polkitd "${EROOT}"/var/lib/polkit-1
}
