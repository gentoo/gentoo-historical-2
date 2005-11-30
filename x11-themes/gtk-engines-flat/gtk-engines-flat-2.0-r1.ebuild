# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-flat/gtk-engines-flat-2.0-r1.ebuild,v 1.1 2003/06/19 09:44:44 liquidx Exp $

inherit gtk-engines2

MY_PN=${PN/gtk-engines-flat/gtk-flat-theme}

IUSE=""
DESCRIPTION="GTK+1 and GTK+2 Flat Theme Engine"
SRC_URI="mirror://gnome/teams/art.gnome.org/themes/gtk/Flat-1.2.x.tar.gz
	http://download.freshmeat.net/themes/gtk2flat/gtk2flat-default.tar.gz"
HOMEPAGE="http://art.gnome.org/show_theme.php?themeID=56&category=gtk
	http://themes.freshmeat.net/projects/gtk2flat/"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
LICENSE="GPL-2"
SLOT="2"

GTK1_S=${WORKDIR}/${MY_PN}-0.1
GTK2_S=${WORKDIR}/${MY_PN}-2.0
