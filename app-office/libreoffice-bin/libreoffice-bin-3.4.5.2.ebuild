# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/libreoffice-bin/libreoffice-bin-3.4.5.2.ebuild,v 1.2 2012/02/16 08:55:36 scarabeus Exp $

EAPI=4

KDE_REQUIRED="optional"
CMAKE_REQUIRED="never"

BASE_AMD64_URI="http://dev.gentoo.org/~pacho/libreoffice/"
BASE_X86_URI="http://gentoo-pr.org/libreo/libreo/"

inherit kde4-base java-pkg-opt-2 pax-utils

DESCRIPTION="LibreOffice, a full office productivity suite. Binary package"
HOMEPAGE="http://www.libreoffice.org"
SRC_URI_AMD64="
	kde? (
		!java? ( ${BASE_AMD64_URI}/${PN/-bin}-kde-${PVR}.tbz2 -> ${PN/-bin}-kde-amd64-${PVR}.tbz2 )
		java? ( ${BASE_AMD64_URI}/${PN/-bin}-kde-java-${PVR}.tbz2 -> ${PN/-bin}-kde-java-amd64-${PVR}.tbz2 )
	)
	gnome? (
		!java? ( ${BASE_AMD64_URI}/${PN/-bin}-gnome-${PVR}.tbz2 -> ${PN/-bin}-gnome-amd64-${PVR}.tbz2 )
		java? ( ${BASE_AMD64_URI}/${PN/-bin}-gnome-java-${PVR}.tbz2 -> ${PN/-bin}-gnome-java-amd64-${PVR}.tbz2 )
	)
	!kde? ( !gnome? (
		!java? ( ${BASE_AMD64_URI}/${PN/-bin}-base-${PVR}.tbz2 -> ${PN/-bin}-base-amd64-${PVR}.tbz2 )
		java? ( ${BASE_AMD64_URI}/${PN/-bin}-base-java-${PVR}.tbz2 -> ${PN/-bin}-base-java-amd64-${PVR}.tbz2 )
	) )
"

SRC_URI_X86="
	kde? (
		!java? ( ${BASE_X86_URI}/${PN/-bin}-kde-${PVR}.tbz2 -> ${PN/-bin}-kde-x86-${PVR}.tbz2 )
		java? ( ${BASE_X86_URI}/${PN/-bin}-kde-java-${PVR}.tbz2 -> ${PN/-bin}-kde-java-x86-${PVR}.tbz2 )
	)
	gnome? (
		!java? ( ${BASE_X86_URI}/${PN/-bin}-gnome-${PVR}.tbz2 -> ${PN/-bin}-gnome-x86-${PVR}.tbz2 )
		java? ( ${BASE_X86_URI}/${PN/-bin}-gnome-java-${PVR}.tbz2 -> ${PN/-bin}-gnome-java-x86-${PVR}.tbz2 )
	)
	!kde? ( !gnome? (
		!java? ( ${BASE_X86_URI}/${PN/-bin}-base-${PVR}.tbz2 -> ${PN/-bin}-base-x86-${PVR}.tbz2 )
		java? ( ${BASE_X86_URI}/${PN/-bin}-base-java-${PVR}.tbz2 -> ${PN/-bin}-base-java-x86-${PVR}.tbz2 )
	) )
"

SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )
"

IUSE="gnome java kde"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

COMMON_DEPEND="
	app-arch/zip
	app-arch/unzip
	>=app-text/hunspell-1.3.2-r3
	app-text/mythes
	app-text/libwpd:0.9[tools]
	app-text/libwpg:0.2
	>=app-text/libwps-0.2.2
	dev-db/unixODBC
	dev-libs/expat
	>=dev-libs/glib-2.28
	>=dev-libs/hyphen-2.7.1
	>=dev-libs/icu-4.8.1-r1
	>=dev-lang/perl-5.0
	>=dev-libs/openssl-1.0.0e
	>=dev-libs/redland-1.0.14[ssl]
	media-libs/freetype:2
	>=media-libs/fontconfig-2.8.0
	>=media-libs/libpng-1.5
	net-print/cups
	sci-mathematics/lpsolve
	>=sys-libs/db-4.8
	virtual/jpeg
	>=x11-libs/cairo-1.10.0[X]
	x11-libs/libXaw
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	>=dev-libs/dbus-glib-0.92
	gnome? (
		gnome-base/gconf:2
		gnome-extra/evolution-data-server
	)
	>=x11-libs/gtk+-2.24:2
	media-gfx/graphite2
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-base-0.10
	java? (
		>=dev-java/bsh-2.0_beta4
		dev-java/lucene:2.9
		dev-java/lucene-analyzers:2.3
		dev-java/saxon:0
	)
	virtual/opengl
	net-libs/neon
"

RDEPEND="${COMMON_DEPEND}
	!app-office/libreoffice
	!app-office/openoffice-bin
	!app-office/openoffice
	java? ( >=virtual/jre-1.6 )
"

PDEPEND="
	=app-office/libreoffice-l10n-$(get_version_component_range 1-3)*
"

DEPEND="${COMMON_DEPEND}"

# only one flavor at a time
REQUIRED_USE="kde? ( !gnome ) gnome? ( !kde )"

RESTRICT="test strip"

S="${WORKDIR}"

PYTHON_UPDATER_IGNORE="1"

pkg_pretend() {
	[[ $(gcc-major-version) -lt 4 ]] || \
			( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -le 4 ]] ) \
		&& die "Sorry, but gcc-4.4 and earlier won't work for libreoffice-bin package (see bug #387515)."
}

pkg_setup() {
	kde4-base_pkg_setup
}

src_unpack() {
	default
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	dodir /usr
	cp -aR "${S}"/usr/* "${ED}"/usr/

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${T}/50-${PN}"

}

pkg_preinst() {
	# Cache updates - all handled by kde eclass for all environments
	kde4-base_pkg_preinst
}

pkg_postinst() {
	kde4-base_pkg_postinst

	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/libreoffice/program/soffice.bin
}

pkg_postrm() {
	kde4-base_pkg_postrm
}
