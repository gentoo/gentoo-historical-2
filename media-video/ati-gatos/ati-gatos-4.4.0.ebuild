# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ati-gatos/ati-gatos-4.4.0.ebuild,v 1.2 2004/10/04 06:20:11 spyderous Exp $

inherit eutils

IUSE=""

SNAPSHOT=20040930
MYP=${P}-${SNAPSHOT}

DESCRIPTION="ATI Multimedia-capable drivers for Xorg"
SRC_URI="mirror://gentoo/${MYP}.tar.bz2"
HOMEPAGE="http://gatos.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="${DEPEND}
	>=x11-base/xorg-x11-6.7.0-r1"

pkg_setup() {
	if [ ! "`grep sdk /var/db/pkg/x11-base/xorg-x11-[0-9]*/USE`" ]
	then
		ewarn "This package requires that xorg-x11 was merged with the sdk USE flag enabled."
		die "Please merge xorg-x11 with the sdk USE flag enabled."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	if has_version '>=x11-base/xorg-x11-6.7.99*'
	then
		einfo "Patching ati-gatos for use with >=x11-base/xorg-x11-6.7.99"
		epatch ${FILESDIR}/${P}-new-xorg.patch
	fi

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
	einfo "To have Xorg make use of the new GATOS modules, you should add the following"
	einfo "line to /etc/X11/XF86Config, in the files section and above any other"
	einfo "ModulePath directives:"
	einfo
	einfo "      ModulePath \"/usr/X11R6/lib/modules-extra/gatos\""
	einfo
	einfo "Please note that you may need to uncomment or add another ModulePath line with"
	einfo "the default module path in it. If Xorg does not start after adding the line"
	einfo "above, add this one under it:"
	einfo
	einfo "      ModulePath \"/usr/X11R6/lib/modules\""
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
