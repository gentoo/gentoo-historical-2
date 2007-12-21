# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-qt3support/qt-qt3support-4.4.0_rc1.ebuild,v 1.6 2007/12/21 19:36:23 caleb Exp $

inherit qt4-build

SRCTYPE="preview-opensource-src"
DESCRIPTION="The Qt3 support module for the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

MY_PV=${PV/_rc/-tp}

SRC_URI="ftp://ftp.trolltech.com/pub/qt/source/qt-x11-${SRCTYPE}-${MY_PV}.tar.gz"
S=${WORKDIR}/qt-x11-${SRCTYPE}-${MY_PV}

LICENSE="|| ( QPL-1.0 GPL-2 )"
SLOT="4"
KEYWORDS="~x86"

IUSE="debug accessibility"

RDEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-sql-${PV}"

DEPEND="${RDEPEND}"

pkg_setup() {
	if use accessibility && !built_with_use =x11-libs/qt-gui-4* accessibility; then
		eerror "Attempting to build qt3support with accessibility use flag without support in Qt4."
		eerror "You must either turn off this use flag or re-emerge x11-libs/qt with accessibility support."
		die
	fi

	if !built_with_use =x11-libs/qt-core-4* qt3support; then
		eerror "In order for the qt-qt3support package to install, you must set the \"qt3support\" use flag, then"
		eerror "re-emerge the following packages: x11-libs/qt-core, x11-libs/qt-gui, x11-libs/qt-sql."
		die
	fi
}

src_unpack() {
	qt4-build_src_unpack

	skip_qmake_build_patch
	skip_project_generation_patch
	install_binaries_to_buildtree
}

src_compile() {
	local myconf=$(standard_configure_options)

	# Add a switch that will attempt to use recent binutils to reduce relocations.  Should be harmless for other
	# cases.  From bug #178535
	use accessibility && myconf="${myconf} -accessibility" || myconf="${myconf} -no-accessibility"

	myconf="${myconf} -qt3support"

	echo ./configure ${myconf}
	./configure ${myconf} || die

	build_directories src/qt3support tools/designer/src/plugins/widgets tools/qtconfig src/tools/uic3
}

src_install() {
	install_directories src/qt3support tools/designer/src/plugins/widgets tools/qtconfig src/tools/uic3

	fix_library_files
}

# Don't postinst qt3support into qconfig.pri here, it's handled in qt-core by way of the use flag.


