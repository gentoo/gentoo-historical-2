# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/mythfrontend/mythfrontend-0.14-r1.ebuild,v 1.3 2004/04/26 18:36:23 agriffis Exp $

inherit flag-o-matic

DESCRIPTION="Homebrew PVR project frontend."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/mythtv-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa arts dvb directfb lcd lirc nvidia cle266"

DEPEND="virtual/x11
	>=x11-libs/qt-3.1
	>=media-sound/lame-3.93.1
	>=media-libs/freetype-2.0
	>=sys-apps/sed-4
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	directfb? ( dev-libs/DirectFB )
	dvb? ( media-libs/libdvb )
	lcd? ( app-misc/lcdproc )
	lirc? ( app-misc/lirc )
	nvidia? ( media-video/nvidia-glx )
	cle266? ( media-libs/libddmpeg )"

RDEPEND="${DEPEND}
	!media-tv/mythtv"

S="${WORKDIR}/mythtv-${PV}"

pkg_setup() {
	local qt_use="$(</var/db/pkg/`best_version x11-libs/qt`/USE)"
	if [ ! "`has mysql ${qt_use}`" ] ; then
		eerror "Qt is missing MySQL support. Please add"
		eerror "'mysql' to your USE flags, and re-emerge Qt."
		die "Qt needs MySQL support"
	fi

	return 0
}

src_unpack() {
	unpack ${A} && cd ${S}

	for i in `grep -lr "usr/local" "${S}"` ; do
		sed -e "s:usr/local:usr:g" -i "${i}" || die "sed failed"
	done
}

src_compile() {
	# Fix bugs 40964 and 42943.
	filter-flags -fforce-addr -fPIC

	if [ "${ARCH}" == "amd64" ]; then
		sed -e "s:-march=pentiumpro::" -e "/DEFINES += MMX/d" -i settings.pro
	else
		local cpu="`get-flag march || get-flag mcpu`"
		if [ "${cpu}" ] ; then
			sed -e "s:pentiumpro:${cpu}:g" -i "settings.pro" || die "sed failed"
		fi
	fi

	if [ "`use alsa`" ] ; then
		sed -e 's:#CONFIG += using_alsa:CONFIG += using_alsa:' \
			-e 's:#ALSA_LIBS = -lasound:ALSA_LIBS = -lasound:' \
			-i 'settings.pro' || die "enable alsa sed failed"
	fi
	if [ "`use arts`" ] ; then
		sed -e 's:artsc/artsc.h:artsc.h:' \
			-i "libs/libmyth/audiooutputarts.h" || die "sed failed"
		sed -e 's:#CONFIG += using_arts:CONFIG += using_arts:' \
			-e 's:#ARTS_LIBS = .*:ARTS_LIBS = `artsc-config --libs`:' \
			-e 's:#EXTRA_LIBS += -L/opt/.*:EXTRA_LIBS += `artsc-config --libs`:' \
			-e 's:#INCLUDEPATH += /opt/.*:QMAKE_CXXFLAGS += `artsc-config --cflags`:' \
			-i 'settings.pro' || die "enable arts sed failed"
	fi
	if [ "`use directfb`" ] ; then
		sed -e 's:#CONFIG += using_directfb:CONFIG += using_directfb:' \
			-e 's:#EXTRA_LIBS += `directfb:EXTRA_LIBS += `directfb:' \
			-e 's:#QMAKE_CXXFLAGS += `directfb:QMAKE_CXXFLAGS += `directfb:' \
			-i 'settings.pro' || die "enable arts sed failed"
	fi
	if [ "`use dvb`" ] ; then
		sed -e 's:#CONFIG += using_dvb:CONFIG += using_dvb:' \
			-e 's:#DEFINES += USING_DVB:DEFINES += USING_DVB:' \
			-e 's:#INCLUDEPATH += /usr/src/.*:INCLUDEPATH += /usr/include:' \
			-i 'settings.pro' || die "enable dvb sed failed"
	fi
	if [ "`use lcd`" ] ; then
		sed -e 's:#DEFINES += LCD_DEVICE:DEFINES += LCD_DEVICE:' \
			-i 'settings.pro' || die "enable lcd sed failed"
	fi
	if [ "`use lirc`" ] ; then
		sed -e 's:#CONFIG += using_lirc:CONFIG += using_lirc:' \
			-e 's:#LIRC_LIBS = -llirc_client:LIRC_LIBS = -llirc_client:' \
			-i 'settings.pro' || die "enable lirc sed failed"
	fi
	if [ "`use nvidia`" ] ; then
		sed -e 's:#CONFIG += using_xvmc:CONFIG += using_xvmc:' \
			-e 's:#DEFINES += USING_XVMC:DEFINES += USING_XVMC:' \
			-e 's:#EXTRA_LIBS += -lXvMCNVIDIA:EXTRA_LIBS += -lXvMCNVIDIA:' \
			-i 'settings.pro' || die "enable xvmc sed failed"
	fi
	if [ "`use cle266`" ] ; then
		sed -e 's:#CONFIG += using_viahwslice:CONFIG += using_viahwslice:' \
			-e 's:#DEFINES += USING_VIASLICE:DEFINES += USING_VIASLICE:' \
			-e 's:#EXTRA_LIBS += -lddmpeg:EXTRA_LIBS += -lddmpeg:' \
			-i 'settings.pro' || die "enable lirc sed failed"
	fi

	qmake -o "Makefile" "mythtv.pro"

	econf || die "econf failed"
	emake -j1 || die "compile problem"
}

src_install() {
	einstall INSTALL_ROOT="${D}"

	dodir /etc/mythtv
	mv "${D}/usr/share/mythtv/mysql.txt" "${D}/etc/mythtv"
	dosym /etc/mythtv/mysql.txt /usr/share/mythtv/mysql.txt

	rm -rf "${D}"/usr/bin/myth{backend,commflag,filldatabase,transcode} \
		"${D}/usr/share/mythtv/setup.xml"

	dodoc AUTHORS COPYING FAQ README UPGRADING keys.txt docs/*.{txt,pdf}
	dohtml docs/*.html
}
