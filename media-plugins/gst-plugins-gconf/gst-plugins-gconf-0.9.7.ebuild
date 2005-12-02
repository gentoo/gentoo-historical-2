# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gconf/gst-plugins-gconf-0.9.7.ebuild,v 1.1 2005/12/02 22:32:20 zaheerm Exp $

inherit gnome2 gst-plugins-good gst-plugins10

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=gnome-base/gconf-2.0"
GST_PLUGINS_BUILD="gconf gconftool"

# override eclass
src_unpack() {

	local makefiles

	unpack ${A}

}

src_compile() {

	gst-plugins-good_src_configure ${@}

	gst-plugins10_find_plugin_dir
	emake || die "compile failure"

	cd ${S}/gconf
	emake || die "compile failure"

}
src_install() {

	gst-plugins10_find_plugin_dir
	einstall || die

	cd ${S}/gconf
	gnome2_src_install || die
}
