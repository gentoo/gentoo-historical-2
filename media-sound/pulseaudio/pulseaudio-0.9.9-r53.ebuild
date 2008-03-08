# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pulseaudio/pulseaudio-0.9.9-r53.ebuild,v 1.1 2008/03/08 23:34:01 flameeyes Exp $

EAPI=1

inherit eutils libtool autotools flag-o-matic

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="http://0pointer.de/lennart/projects/pulseaudio/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"
IUSE="alsa avahi caps jack lirc oss tcpd X hal dbus libsamplerate gnome bluetooth policykit asyncns +glib"

RDEPEND="X? ( x11-libs/libX11 )
	caps? ( sys-libs/libcap )
	>=media-libs/audiofile-0.2.6-r1
	libsamplerate? ( >=media-libs/libsamplerate-0.1.1-r1 )
	>=media-libs/libsndfile-1.0.10
	>=dev-libs/liboil-0.3.6
	alsa? ( >=media-libs/alsa-lib-1.0.10 )
	glib? ( >=dev-libs/glib-2.4.0 )
	avahi? ( >=net-dns/avahi-0.6.12 )
	>=dev-libs/liboil-0.3.0
	jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
	tcpd? ( sys-apps/tcp-wrappers )
	lirc? ( app-misc/lirc )
	dbus? ( >=sys-apps/dbus-1.0.0 )
	gnome? ( >=gnome-base/gconf-2.4.0 )
	hal? (
		>=sys-apps/hal-0.5.7
		>=sys-apps/dbus-1.0.0
	)
	app-admin/eselect-esd
	bluetooth? (
		>=net-wireless/bluez-libs-3
		>=sys-apps/dbus-1.0.0
	)
	policykit? ( sys-auth/policykit )
	asyncns? ( net-libs/libasyncns )
	>=sys-apps/baselayout-2.0_rc5
	>=sys-devel/libtool-1.5.24" # it's a valid RDEPEND, libltdl.so is used
DEPEND="${RDEPEND}
	dev-libs/libatomic_ops
	dev-util/pkgconfig
	dev-util/unifdef"

# alsa-utils dep is for the alsasound init.d script (see bug #155707)
# bluez-utils dep is for the bluetooth init.d script
RDEPEND="${RDEPEND}
	gnome-extra/gnome-audio
	alsa? ( media-sound/alsa-utils )
	bluetooth? ( >=net-wireless/bluez-utils-3 )"

pkg_setup() {
	if use avahi && ! built_with_use net-dns/avahi dbus ; then
		echo
		eerror "In order to compile pulseaudio with avahi support, you need to have"
		eerror "net-dns/avahi emerged with 'dbus' in your USE flag. Please add that"
		eerror "flag, re-emerge avahi, and then emerge pulseaudio again."
		die "net-dns/avahi is missing the D-Bus bindings."
	fi

	enewgroup audio 18 # Just make sure it exists
	enewgroup realtime
	enewgroup pulse-access
	enewgroup pulse
	enewuser pulse -1 -1 /var/run/pulse pulse,audio
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-0.9.8-svn2074.patch"
	epatch "${FILESDIR}/${PN}-0.9.8-polkit.patch"
	epatch "${FILESDIR}/${PN}-0.9.8-bt-nohal.patch"
	epatch "${FILESDIR}/${PN}-0.9.8-esoundpath.patch"
	epatch "${FILESDIR}/${PN}-0.9.8-create-directory.patch"
	epatch "${FILESDIR}/${P}+ltdl-2.2.patch"

	eautoreconf
	elibtoolize
}

src_compile() {
	# To properly fix CVE-2008-0008
	append-flags -UNDEBUG

	econf \
		--enable-largefile \
		$(use_enable glib) \
		--disable-solaris \
		$(use_enable asyncns) \
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable lirc) \
		$(use_enable tcpd tcpwrap) \
		$(use_enable jack) \
		$(use_enable lirc) \
		$(use_enable avahi) \
		$(use_enable hal) \
		$(use_enable dbus) \
		$(use_enable gnome gconf) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable bluetooth bluez) \
		$(use_enable policykit polkit) \
		$(use_with caps) \
		$(use_with X x) \
		--disable-ltdl-install \
		--localstatedir=/var \
		--with-realtime-group=realtime \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "make install failed"

	newconfd "${FILESDIR}/pulseaudio.conf.d" pulseaudio

	use_define() {
		local define=${2:-$(echo $1 | tr '[:lower:]' '[:upper:]')}

		use "$1" && echo "-D$define" || echo "-U$define"
	}

	unifdef "${FILESDIR}/pulseaudio.init.d-3" \
		$(use_define hal) \
		$(use_define avahi) \
		$(use_define alsa) \
		$(use_define bluetooth) \
		> "${T}/pulseaudio"
	doinitd "${T}/pulseaudio"

	use avahi && sed -i -e '/module-zeroconf-publish/s:^#::' "${D}/etc/pulse/default.pa"

	dohtml -r doc
	dodoc README

	# Create the state directory
	diropts -o pulse -g pulse -m0755
	keepdir /var/run/pulse
}

pkg_postinst() {
	elog "PulseAudio in Gentoo can use a system-wide pulseaudio daemon."
	elog "This support is enabled by starting the pulseaudio init.d ."
	elog "To be able to access that you need to be in the group pulse-access."
	elog "For more information about system-wide support, please refer to"
	elog "	 http://pulseaudio.org/wiki/SystemWideInstance"
	if use gnome; then
		elog
		elog "By enabling gnome USE flag, you enabled gconf support. Pleaes note"
		elog "that you might need to remove the gnome USE flag or disable the"
		elog "gconf module on /etc/pulse/default.pa to be able to use PulseAudio"
		elog "with a system-wide instance."
	fi
	elog
	elog "To use the ESounD wrapper while using a system-wide daemon, you also"
	elog "need to enable auth-anonymous for the esound-unix module, or to copy"
	elog "/var/run/pulse/.esd_auth into each home directory."
	elog
	elog "If you want to make use of realtime capabilities of PulseAudio"
	elog "you should follow the realtime guide to create and set up a realtime"
	elog "user group: http://www.gentoo.org/proj/en/desktop/sound/realtime.xml"
	elog "Make sure you also have baselayout installed with pam USE flag"
	elog "enabled, if you're using the rlimit method."
	if use bluetooth; then
		elog
		elog "The BlueTooth proximity module is not enabled in the default"
		elog "configuration file. If you do enable it, you'll have to have"
		elog "your BlueTooth controller enabled and inserted at bootup or"
		elog "PulseAudio will refuse to start."
		elog
		elog "Please note that the BlueTooth proximity module seems itself"
		elog "still experimental, so please report to upstream if you have"
		elog "problems with it."
	fi

	eselect esd update --if-unset
}
