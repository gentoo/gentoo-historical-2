# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fusionx-aqua/fusionx-aqua-1.1.ebuild,v 1.6 2004/04/27 19:54:53 pvdabeel Exp $

inherit kde
need-kde 3.1

MY_P="FusionX-Aqua-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="stylish \"Fusion X Aqua\" theme for KDE"
HOMEPAGE="http://www.kdelook.org/content/show.php?content=5296"
SRC_URI="http://www.kdelook.org/content/files/5296-${MY_P}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~alpha"

DEPEND="kde-base/kdebase"

src_compile(){
	# nothing to compile, but don't want the eclass to try to compile anything
	return 0
}

src_install(){
	mkdir -p ${D}/${KDEDIR}/share/apps/kstyle
	cp -R -f ${WORKDIR}/${MY_P}/pixmaps ${D}/${KDEDIR}/share/apps/kstyle/ || die
	cp -R -f ${WORKDIR}/${MY_P}/themes ${D}/${KDEDIR}/share/apps/kstyle/ || die
	mkdir -p ${D}/${KDEDIR}/share/apps/kwin
	cp -R -f ${WORKDIR}/${MY_P}/icewm-themes ${D}/${KDEDIR}/share/apps/kwin || die
	mkdir -p ${D}/${KDEDIR}/share/apps/kdisplay
	cp -R -f ${WORKDIR}/${MY_P}/color-schemes ${D}/${KDEDIR}/share/apps/kdisplay || die
	dodoc ${WORKDIR}/${MY_P}/{CREDITS,README,CHANGELOG}
}

pkg_postinst(){
	einfo "This theme is an IceWM pixmap theme for KDE."
	einfo ""
	einfo "To use this theme set the following options in the"
	einfo "KDE Control Center:"
	einfo " o Appearance & Themes"
	einfo "   - Style = \"fusionx-aqua\""
	einfo "   - Window Decorations = \"IceWM\""
	einfo "     - Configuration [IceWM] = \"fusionX-aqua\""
	einfo ""
	einfo "To make the theme visible in any currently running KDE session"
	einfo "execute the following command from a shell or the"
	einfo "KDE \"Run Command\" dialog:"
	einfo "   kinstalltheme"
}
