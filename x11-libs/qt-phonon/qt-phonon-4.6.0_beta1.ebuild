# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-phonon/qt-phonon-4.6.0_beta1.ebuild,v 1.1 2009/10/16 16:51:03 wired Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The Phonon module for the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

DEPEND="~x11-libs/qt-gui-${PV}[debug=,glib,qt3support]
	!kde-base/phonon-kde
	!kde-base/phonon-xine
	!media-sound/phonon
	media-libs/gstreamer
	media-libs/gst-plugins-base
	dbus? ( =x11-libs/qt-dbus-${PV}[debug=] )"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
src/phonon
src/plugins/phonon"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/
src"

QCONFIG_ADD="phonon"
QCONFIG_DEFINE="QT_GSTREAMER"

src_configure() {
	myconf="${myconf} -phonon -phonon-backend -no-opengl -no-svg
		$(qt_use dbus qdbus)"

	qt4-build_src_configure
}
