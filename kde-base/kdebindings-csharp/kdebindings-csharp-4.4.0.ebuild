# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-csharp/kdebindings-csharp-4.4.0.ebuild,v 1.2 2010/02/09 16:56:22 scarabeus Exp $

EAPI="2"

KMNAME="kdebindings"
KMMODULE="csharp"
WEBKIT_REQUIRED="optional"
inherit kde4-meta mono

DESCRIPTION="C# bindings for KDE and Qt"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="akonadi +phonon plasma qscintilla webkit"

DEPEND="
	dev-lang/mono
	$(add_kdebase_dep smoke 'akonadi?,phonon?,qscintilla?,webkit?')
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="smoke/"

pkg_setup() {
	kde4-meta_pkg_setup

	if use plasma && ! use webkit; then
		eerror
		eerror "The plasma USE flag requires the webkit USE flag to be enabled."
		eerror
		eerror "Please enable webkit or disable plasma."
		die "plasma requires webkit"
	fi
}

src_prepare() {
	kde4-meta_src_prepare

	sed -i "/add_subdirectory( examples )/ s:^:#:" csharp/plasma/CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable webkit QTWEBKIT_SHARP)
		$(cmake-utils_use_enable plasma PLASMA_SHARP)
		$(cmake-utils_use_enable phonon PHONON_SHARP)
		$(cmake-utils_use_enable qscintilla QSCINTILLA_SHARP)
		$(cmake-utils_use_enable akonadi KdepimLibs)
		$(cmake-utils_use_enable akonadi)
	)
	kde4-meta_src_configure
}

src_compile() {
	# Parallel builds seem broken, check later
	MAKEOPTS=-j1
	kde4-meta_src_compile
}
