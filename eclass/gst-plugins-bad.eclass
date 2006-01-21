# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gst-plugins-bad.eclass,v 1.1 2006/01/21 01:29:12 compnerd Exp $

#
# Original Author: Saleem Abdulrasool <compnerd@gentoo.org>
# Based on the work of foser <foser@gentoo.org> and zaheerm <zaheerm@gentoo.org>
# Purpose: This elcass is designed to help package external gst-plugins per
# plugin rather than in a single package.
#

my_plugins="directfb faac faad gsm ivorbis libmms musepack sdl wavpack"
#qtdemux spped tta

inherit eutils gst-plugins10

MY_PN="gst-plugins-bad"
MY_P=${MY_PN}-${PV}

SRC_URI="http://gstreamer.freedesktop.org/src/gst-plugins-bad/${MY_P}.tar.bz2"

RDEPEND=">=media-libs/gstreamer-0.10
		 >=media-libs/gst-plugins-base-0.10
		 >=dev-libs/glib-2.6
		 >=dev-libs/liboil-0.3"
DEPEND="${RDEPEND}
		sys-apps/sed
		sys-devel/gettext"

S=${WORKDIR}/${MY_P}

gst-plugins-bad_src_unpack() {
	local makefiles

	unpack ${A}

	gst-plugins10_find_plugin_dir
	cd ${S}

	# Remove generation of any other Makefiles except the plugin's Makefile
	if [[ -d "${S}/sys/${GST_PLUGINS_BUILD_DIR}" ]] ; then
		makefiles="Makefile sys/Makefile sys/${GST_PLUINGS_BUILD_DIR}/Makefile"
	elif [[ -d "${S}/ext/${GST_PLUGINS_BUILD_DIR}" ]] ; then
		makefiles="Makefile ext/Makefile ext/${GST_PLUGINS_BUILD_DIR}/Makefile"
	fi

	sed -e "s:ac_config_files=.*:ac_config_files='${makefiles}':" \
		-i ${S}/configure
}

gst-plugins-bad_src_configure() {
	local plugin gst_conf

	einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."

	for plugin in ${GST_PLUGINS_BUILD} ; do
		my_plugins="${my_plugins/${plugin}/}"
	done

	for plugin in ${my_plugins} ; do
		gst_conf="${gst_conf} --disable-${plugin}"
	done

	for plugin in ${GST_PLUINGS_BUILD} ; do
		gst_conf="${gst_conf} --enable-${plugin}"
	done

	cd ${S}
	econf ${@} ${gst_conf} || die "configure failed"
}

gst-plugins-bad_src_compile() {
	gst-plugins-bad_src_configure ${@}

	gst-plugins10_find_plugin_dir
	emake || die "compile failure"
}

gst-plugins-bad_src_install() {
	gst-plugins10_find_plugin_dir
	einstall || die "install failed"

	dodoc README
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
