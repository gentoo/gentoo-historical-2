# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ati-gatos/ati-gatos-4.4.0.ebuild,v 1.6 2007/05/01 00:42:38 genone Exp $

inherit eutils

SNAPSHOT=20040930
MYP=${P}-${SNAPSHOT}

DESCRIPTION="ATI Multimedia-capable drivers for Xorg"
HOMEPAGE="http://gatos.sourceforge.net/"
SRC_URI="mirror://gentoo/${MYP}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-base/xorg-x11-6.7.0-r1"

pkg_setup() {
	if ! built_with_use x11-base/xorg-x11 sdk ; then
		ewarn "This package requires that xorg-x11 was merged with the sdk USE flag enabled."
		die "Please merge xorg-x11 with the sdk USE flag enabled."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	if has_version '>x11-base/xorg-x11-6.7' ; then
		einfo "Patching ati-gatos for use with >=x11-base/xorg-x11-6.7.99"
		epatch ${FILESDIR}/${P}-new-xorg.patch
	fi

	epatch ${FILESDIR}/${P}-prototypes.patch

	# Build makefiles against Xorg SDK
	imake -I/usr/X11R6/lib/Server/config/cf -DUseInstalled -DXF86DriverSDK

	# Makefile fixes
	fix_makefile
}

src_compile() {
	cd ${S}

	emake DESTDIR=${D} || die "Problem compiling GATOS drivers."
}

src_install() {
	emake DESTDIR=${D} install
}

pkg_postinst() {
	elog "To have Xorg make use of the new GATOS modules, you should add the following"
	elog "line to /etc/X11/XF86Config, in the files section and above any other"
	elog "ModulePath directives:"
	elog
	elog "      ModulePath \"/usr/X11R6/lib/modules-extra/gatos\""
	elog
	elog "Please note that you may need to uncomment or add another ModulePath line with"
	elog "the default module path in it. If Xorg does not start after adding the line"
	elog "above, add this one under it:"
	elog
	elog "      ModulePath \"/usr/X11R6/lib/modules\""
}

fix_makefile() {
	cp Makefile Makefile.orig

	# Add the Xorg SDK include directories that gatos will use
	sed -i -e "s:\ *INCLUDES = \(.\+\):INCLUDES = \\1 -I/usr/X11R6/lib/Server/include -I/usr/X11R6/lib/Server/include/extensions:" Makefile

	# Clean up the ugly sandbox violations
	sed -i -e "s:\(\ \+\)MODULEDIR = .*:\\1MODULEDIR = \\\$(USRLIBDIR)/modules-extra/gatos:" Makefile
	sed -i -e "s:\(\ \+\)BUILDLIBDIR = .*:\\1BUILDLIBDIR = \\\$(DESTDIR)\\\$(TOP)/exports/lib:" Makefile
	sed -i -e "s:\$(RM) \$(BUILDMODULEDIR):\$(RM) \$(DESTDIR)\$(BUILDMODULEDIR):g" Makefile
}
