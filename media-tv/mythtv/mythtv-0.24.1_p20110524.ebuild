# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/mythtv/mythtv-0.24.1_p20110524.ebuild,v 1.3 2012/03/07 16:17:17 pesa Exp $

EAPI=3
PYTHON_DEPEND="2"
MYTHTV_VERSION="v0.24.1-1-g347cd24"
MYTHTV_BRANCH="fixes/0.24"
MYTHTV_REV="347cd2477ad82a7aa75ebe7c686db77465f415dc"
MYTHTV_SREV="347cd24"

inherit flag-o-matic multilib eutils toolchain-funcs python linux-info versionator

DESCRIPTION="Homebrew PVR project"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE_VIDEO_CARDS="video_cards_nvidia"
IUSE="altivec autostart dvb \
dvd bluray \
ieee1394 jack lcd lirc \
alsa jack \
debug profile \
perl python \
xvmc vdpau \
${IUSE_VIDEO_CARDS} \
input_devices_joystick \
"

RDEPEND=">=media-libs/freetype-2.0
	>=media-sound/lame-3.93.1
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXv
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	x11-libs/qt-core:4[qt3support]
	x11-libs/qt-gui:4[qt3support]
	x11-libs/qt-sql:4[qt3support,mysql]
	x11-libs/qt-opengl:4[qt3support]
	x11-libs/qt-webkit:4
	virtual/mysql
	virtual/opengl
	virtual/glu
	|| ( >=net-misc/wget-1.9.1 >=media-tv/xmltv-0.5.43 )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	autostart? ( net-dialup/mingetty
				 x11-wm/evilwm
				 x11-apps/xset )
	dvb? ( media-libs/libdvb virtual/linuxtv-dvb-headers )
	dvd? ( media-libs/libdvdcss )
	ieee1394? (	>=sys-libs/libraw1394-1.2.0
			    >=sys-libs/libavc1394-0.5.3
			    >=media-libs/libiec61883-1.0.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	lcd? ( app-misc/lcdproc )
	lirc? ( app-misc/lirc )
	perl? ( dev-perl/DBD-mysql
			dev-perl/Net-UPnP
			>=dev-perl/libwww-perl-6 )
	python? ( dev-python/mysql-python
			dev-python/lxml )
	xvmc? ( x11-libs/libXvMC )
	bluray? ( media-libs/libbluray )
	video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-180.06 )
	media-fonts/corefonts
	media-fonts/dejavu
	!media-tv/mythtv-bindings
	"

DEPEND="${RDEPEND}
	dev-lang/yasm
	x11-proto/xineramaproto
	x11-proto/xf86vidmodeproto
	x11-apps/xinit
	"

MYTHTV_GROUPS="video,audio,tty,uucp"

# Release version
MY_PV="${PV%_*}"

# what product do we want
case "${PN}" in
	mythtv)
		REPO="mythtv"
		MY_PN="mythtv"
		S="${WORKDIR}/MythTV-${REPO}-${MYTHTV_SREV}/${MY_PN}"
		;;
	mythtv-bindings)
		REPO="mythtv"
		MY_PN="mythtv"
		S="${WORKDIR}/MythTV-${REPO}-${MYTHTV_SREV}/${MY_PN}"
		;;
	mythweb)
		REPO="mythweb"
		MY_PN="mythweb"
		S="${WORKDIR}/MythTV-${REPO}-${MYTHTV_SREV}/"
		;;
	nuvexport)
		REPO="nuvexport"
		MY_PN="nuvexport"
		MYTHTV_REV="$NUVEXPORT_REV"
		S="${WORKDIR}/MythTV-${REPO}-${NUVEXPORT_SREV}/"
		;;
	*)
		REPO="mythtv"
		MY_PN="mythplugins"
		S="${WORKDIR}/MythTV-${REPO}-${MYTHTV_SREV}/${MY_PN}"
		;;
esac

# _pre is from SVN trunk while _p and _beta are from SVN ${MY_PV}-fixes
# TODO: probably ought to do something smart if the regex doesn't match anything
[[ "${PV}" =~ (_alpha|_beta|_pre|_rc|_p)([0-9]+) ]] || {
	# assume a tagged release
	MYTHTV_REV="v${PV}"
}

HOMEPAGE="http://www.mythtv.org"
LICENSE="GPL-2"
SRC_URI="https://github.com/MythTV/${REPO}/tarball/${MYTHTV_REV} -> ${REPO}-${PV}.tar.gz"

pkg_setup() {
	einfo "This ebuild now uses a heavily stripped down version of your CFLAGS"

	if use xvmc && use video_cards_nvidia
	then
		elog
		elog "For NVIDIA based cards, the XvMC renderer only works on"
		elog "the NVIDIA 4, 5, 6 & 7 series cards."
	fi

	python_set_active_version 2

	enewuser mythtv -1 /bin/bash /home/mythtv ${MYTHTV_GROUPS}
	usermod -a -G ${MYTHTV_GROUPS} mythtv
}

src_prepare() {
# upstream wants the revision number in their version.cpp
# since the subversion.eclass strips out the .svn directory
# svnversion in MythTV's build doesn't work
sed -e "s#\${SOURCE_VERSION}#${MYTHTV_VERSION}#g" -e "s#\${BRANCH}#${MYTHTV_BRANCH}#g" -i "${S}"/version.sh

# Perl bits need to go into vender_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/bindings/perl/Makefile

	epatch "${FILESDIR}/ffmpeg-sync.patch"
	epatch "${FILESDIR}/fixLdconfSandbox.patch"

	if kernel_is -ge 2 6 38
	then
		epatch "${FILESDIR}/mythtv-v4l2-fix.2.patch"
	fi

}

src_configure() {
	local myconf="--prefix=/usr"
	myconf="${myconf} --mandir=/usr/share/man"
	myconf="${myconf} --libdir-name=$(get_libdir)"

	myconf="${myconf} --enable-pic"
	myconf="${myconf} --enable-proc-opt"

	myconf="${myconf} --enable-disable-mmx-for-debugging"

	use alsa    || myconf="${myconf} --disable-audio-alsa"
	use altivec || myconf="${myconf} --disable-altivec"
	use jack    || myconf="${myconf} --disable-audio-jack"

#from bug #220857
	if use xvmc; then
		myconf="${myconf} --enable-xvmc"
		myconf="${myconf} --enable-xvmcw"
		myconf="${myconf} --disable-xvmc-vld"
	else
		myconf="${myconf} --disable-xvmc"
		myconf="${myconf} --disable-xvmcw"
	fi

	myconf="${myconf} $(use_enable dvb)"
	myconf="${myconf} $(use_enable ieee1394 firewire)"
	myconf="${myconf} $(use_enable lirc)"
	myconf="${myconf} --disable-directfb"
	myconf="${myconf} --dvb-path=/usr/include"
	myconf="${myconf} --enable-opengl-vsync"
	myconf="${myconf} --enable-xrandr"
	myconf="${myconf} --enable-xv"
	myconf="${myconf} --enable-x11"

	if use perl && use python
	then
		myconf="${myconf} --with-bindings=perl,python"
	elif use perl
	then
		myconf="${myconf} --without-bindings=python"
		myconf="${myconf} --with-bindings=perl"
	elif use python
	then
		myconf="${myconf} --without-bindings=perl"
		myconf="${myconf} --with-bindings=python"
	else
		myconf="${myconf} --without-bindings=perl,python"
	fi

	if use debug
	then
		myconf="${myconf} --compile-type=debug"
	elif use profile
	then
		myconf="${myconf} --compile-type=profile"
	else
		myconf="${myconf} --compile-type=release"
		myconf="${myconf} --enable-proc-opt"
	fi

	if use xvmc && use video_cards_nvidia
	then
		myconf="${myconf} --xvmc-lib=XvMCNVIDIA"
		myconf="${myconf} --enable-opengl-video"
	fi

	if use vdpau && use video_cards_nvidia
	then
		myconf="${myconf} --enable-vdpau"
	fi

	use input_devices_joystick || myconf="${myconf} --disable-joystick-menu"

## CFLAG cleaning so it compiles
	strip-flags
	filter-flags "-march=*" "-mtune=*" "-mcpu=*"
	filter-flags "-O" "-O?"

	has distcc ${FEATURES} || myconf="${myconf} --disable-distcc"
	has ccache ${FEATURES} || myconf="${myconf} --disable-ccache"

# let MythTV come up with our CFLAGS. Upstream will support this
	CFLAGS=""
	CXXFLAGS=""

	chmod +x ./external/FFmpeg/version.sh

	einfo "Running ./configure ${myconf}"
	chmod +x ./configure
	./configure ${myconf} || die "configure died"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	einstall INSTALL_ROOT="${D}" || die "install failed"
	dodoc AUTHORS FAQ UPGRADING  README

	insinto /usr/share/mythtv/database
	doins database/*

	exeinto /usr/share/mythtv

	newinitd "${FILESDIR}"/mythbackend-0.18.2.rc mythbackend
	newconfd "${FILESDIR}"/mythbackend-0.18.2.conf mythbackend

	dodoc keys.txt docs/*.{txt,pdf}
	dohtml docs/*.html

	keepdir /etc/mythtv
	chown -R mythtv "${D}"/etc/mythtv
	keepdir /var/log/mythtv
	chown -R mythtv "${D}"/var/log/mythtv

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/mythtv.logrotate.d-r1 mythtv

	insinto /usr/share/mythtv/contrib
	doins -r contrib/*

	dobin "${FILESDIR}"/runmythfe

	if use autostart
	then
		dodir /etc/env.d/
		echo 'CONFIG_PROTECT="/home/mythtv/"' > "${D}"/etc/env.d/95mythtv

		insinto /home/mythtv
		newins "${FILESDIR}"/bash_profile .bash_profile
		newins "${FILESDIR}"/xinitrc .xinitrc
	fi

	for file in `find "${D}" -type f -name \*.py`; do chmod a+x "$file"; done
	for file in `find "${D}" -type f -name \*.sh`; do chmod a+x "$file"; done
	for file in `find "${D}" -type f -name \*.pl`; do chmod a+x "$file"; done
}

pkg_preinst() {
	export CONFIG_PROTECT="${CONFIG_PROTECT} ${ROOT}/home/mythtv/"
}

pkg_postinst() {
	use python && python_mod_optimize MythTV

	elog "Want mythfrontend to start automatically?"
	elog "Set USE=autostart. Details can be found at:"
	elog "http://dev.gentoo.org/~cardoe/mythtv/autostart.html"

	elog
	elog "To always have MythBackend running and available run the following:"
	elog "rc-update add mythbackend default"
	elog
	ewarn "Your recordings folder must be owned by the user 'mythtv' now"
	ewarn "chown -R mythtv /path/to/store"
	ewarn
	elog "Note that USE=-mmx now works with mythtv, but you could suffer"
	elog "from performance issues if you use it."

	if use xvmc && [[ ! -s "${ROOT}/etc/X11/XvMCConfig" ]]
	then
		ewarn
		ewarn "No XvMC implementation has been selected yet"
		ewarn "Use 'eselect xvmc list' for a list of available choices"
		ewarn "Then use 'eselect xvmc set <choice>' to choose"
		ewarn "'eselect xvmc set nvidia' for example"
	fi

	if use autostart
	then
		elog
		elog "Please add the following to your /etc/inittab file at the end of"
		elog "the TERMINALS section"
		elog "c8:2345:respawn:/sbin/mingetty --autologin mythtv tty8"
	fi

}

pkg_postrm()
{
	use python && python_mod_cleanup MythTV
}

pkg_info() {
	"${ROOT}"/usr/bin/mythfrontend --version
}

pkg_config() {
	echo "Creating mythtv MySQL user and mythconverg database if it does not"
	echo "already exist. You will be prompted for your MySQL root password."
	"${ROOT}"/usr/bin/mysql -u root -p < "${ROOT}"/usr/share/mythtv/database/mc.sql
}
