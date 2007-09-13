# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gst-plugins-bad.eclass,v 1.10 2007/09/13 15:38:54 drac Exp $

#
# Original Author: Saleem Abdulrasool <compnerd@gentoo.org>
# Based on the work of foser <foser@gentoo.org> and zaheerm <zaheerm@gentoo.org>
# Purpose: This elcass is designed to help package external gst-plugins per
# plugin rather than in a single package.
#

# This list is current to gst-plugins-bad-0.10.4 except for:
#   gst_v4l2 - moved to gst-plugins-bad-0.10.5 (not in >=gst-plugins-bad-0.10.4)
#              But it must stay in this list until all <gst-plugins-bad-0.10.4
#              are removed
# drac at gentoo.org:
# This list is current to gst-plugins-bad-0.10.5 except for:
#   Not present in 0.10.5 - wavpack
my_gst_plugins_bad="opengl vcd x alsa amrwb bz2 cdaudio directfb dts divx faac
faad gsm gst_v4l2 ivorbis jack ladspa libmms mpeg2enc musepack musicbrainz
mythtv nas neon timidity wildmidi sdl sdltest sndfile soundtouch spc swfdec
theoradec x264 xvid dvb wavpack"

#qtdemux spped tta

inherit eutils gst-plugins10

MY_PN="gst-plugins-bad"
MY_P=${MY_PN}-${PV}

SRC_URI="http://gstreamer.freedesktop.org/src/gst-plugins-bad/${MY_P}.tar.bz2"

# added to remove circular deps
# 6/2/2006 - zaheerm
if [ "${PN}" != "${MY_PN}" ]; then
RDEPEND="=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-base-0.10*
		>=dev-libs/glib-2.6
		>=dev-libs/liboil-0.3"
DEPEND="${RDEPEND}
		sys-apps/sed
		sys-devel/gettext"
fi
S=${WORKDIR}/${MY_P}

gst-plugins-bad_src_unpack() {
	local makefiles

	unpack ${A}

	gst-plugins10_find_plugin_dir
	cd ${S}

	# Remove generation of any other Makefiles except the plugin's Makefile
	if [[ -d "${S}/sys/${GST_PLUGINS_BUILD_DIR}" ]] ; then
		makefiles="Makefile sys/Makefile sys/${GST_PLUGINS_BUILD_DIR}/Makefile"
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
		my_gst_plugins_bad="${my_gst_plugins_bad/${plugin}/}"
	done

	for plugin in ${my_gst_plugins_bad} ; do
		gst_conf="${gst_conf} --disable-${plugin}"
	done

	for plugin in ${GST_PLUGINS_BUILD} ; do
		gst_conf="${gst_conf} --enable-${plugin}"
	done

	cd ${S}
	econf ${@} --with-package-name="Gentoo GStreamer Ebuild" --with-package-origin="http://www.gentoo.org" ${gst_conf} || die "configure failed"
}

gst-plugins-bad_src_compile() {
	gst-plugins-bad_src_configure ${@}

	gst-plugins10_find_plugin_dir
	emake || die "compile failure"
}

gst-plugins-bad_src_install() {
	gst-plugins10_find_plugin_dir
	einstall || die "install failed"

	[[ -e README ]] && dodoc README
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
