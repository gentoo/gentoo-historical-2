# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/thunar/thunar-0.9.0-r1.ebuild,v 1.5 2007/12/12 09:04:33 armin76 Exp $

EAPI=1

inherit eutils virtualx xfce44

MY_P=${P/t/T}
S=${WORKDIR}/${MY_P}

XFCE_VERSION=4.4.2
xfce44

DESCRIPTION="File manager"
HOMEPAGE="http://thunar.xfce.org"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="doc dbus debug exif gnome hal pcre startup-notification +trash-plugin"

RDEPEND=">=dev-lang/perl-5.6
	x11-libs/libSM
	>=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.6
	>=xfce-extra/exo-0.3.4
	>=x11-misc/shared-mime-info-0.20
	>=dev-util/desktop-file-utils-0.14
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	virtual/fam
	dbus? ( dev-libs/dbus-glib )
	hal? ( dev-libs/dbus-glib
		sys-apps/hal )
	>=media-libs/freetype-2
	gnome? ( gnome-base/gconf )
	exif? ( >=media-libs/libexif-0.6 )
	>=media-libs/jpeg-6b
	startup-notification? ( x11-libs/startup-notification )
	pcre? ( >=dev-libs/libpcre-6 )
	trash-plugin? ( dev-libs/dbus-glib
		>=xfce-base/xfce4-panel-${XFCE_MASTER_VERSION} )
	gnome-base/librsvg"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	doc? ( dev-util/gtk-doc )"

XFCE_CONFIG="${XFCE_CONFIG} $(use_enable exif) $(use_enable gnome gnome-thumbnailers) \
	$(use_enable dbus) $(use_enable pcre)"

pkg_setup() {
	local fail="Re-emerge xfce-extra/exo with USE hal."

	if use hal; then
		XFCE_CONFIG="${XFCE_CONFIG} --enable-dbus --with-volume-manager=hal"
	else
		XFCE_CONFIG="${XFCE_CONFIG} --with-volume-manager=none"
	fi

	if use trash-plugin && ! use dbus; then
		XFCE_CONFIG="${XFCE_CONFIG} --enable-dbus"
		ewarn "USE trash-plugin detected, enabling dbus for you."
	fi

	use trash-plugin || XFCE_CONFIG="${XFCE_CONFIG} --disable-tpa-plugin"

	if use hal && ! use dbus; then
		ewarn "USE hal detected, enabling dbus for you."
	fi

	if use hal && ! built_with_use xfce-extra/exo hal; then
		eerror "${fail}"
		die "${fail}"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-missing-audio-cds-for-volman.patch
}

src_test() {
	Xemake check || die "emake check failed."
}

DOCS="AUTHORS ChangeLog HACKING FAQ THANKS TODO README NEWS"

xfce44_extra_package
