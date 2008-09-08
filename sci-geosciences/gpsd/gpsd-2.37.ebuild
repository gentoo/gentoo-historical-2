# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gpsd/gpsd-2.37.ebuild,v 1.3 2008/09/08 03:46:33 nerdboy Exp $

inherit eutils distutils

DESCRIPTION="GPS daemon and library to support USB/serial GPS devices and various GPS/mapping clients."
HOMEPAGE="http://gpsd.berlios.de/"
SRC_URI="mirror://berlios/gpsd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="dbus italk itrax minimal ntp python usb X"
# tnt support is broken in this version - add tntc back when fixed

RDEPEND="X? (
		x11-libs/libXmu
		x11-libs/libXext
		x11-libs/libXp
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXpm
		x11-libs/libXaw
		x11-libs/openmotif
	)
	python? ( dev-lang/python )

	dbus? ( >=sys-apps/dbus-0.94
		>=dev-libs/glib-2.6
		dev-libs/dbus-glib )
	ntp? ( net-misc/ntp )
	usb? ( virtual/dev-manager )"

DEPEND="${RDEPEND}
	X? (
		x11-proto/xproto
		x11-proto/xextproto
	)
	!minimal? (
		dev-libs/libxslt
		sys-libs/ncurses
	)"

src_compile() {

	local my_conf="--enable-shared --with-pic --enable-static \
		--disable-garmin --disable-garmintxt"
	# Garmin support is broken in this version

	use python && distutils_python_version

	if use ntp; then
		my_conf="${my_conf} --enable-ntpshm --enable-pps"
	else
		my_conf="${my_conf} --disable-ntpshm --disable-pps"
	fi

	if use minimal; then
		local max_clients="5"
		local max_devices="2"
		if ! use ntp; then
		my_conf="${my_conf} --disable-pps"
		fi
		my_conf="${my_conf} --enable-squelch --without-x \
		--enable-max-devices=${max_devices} \
		--enable-max-clients=${max_clients}"

		WITH_XSLTPROC=no WITH_XMLTO=no econf ${my_conf} \
		$(use_enable dbus) $(use_enable italk) \
		$(use_enable itrax) $(use_enable python) \
		|| die "econf failed"
	else
		econf ${my_conf} $(use_enable dbus) $(use_enable italk) \
		$(use_enable itrax) $(use_enable python) $(use_with X x) \
		|| die "econf failed"
	fi
	# Support for the TNT digital compass is currently broken
	# $(use_enable tntc tnt)

	emake || die "emake failed"
}

src_install() {

	make DESTDIR="${D}" install || die "make install failed"

	if use usb ; then
		insinto /etc/hotplug/usb
		doins gpsd.usermap
		exeinto /etc/hotplug/usb
		doexe gpsd.hotplug
		insinto /etc/udev/rules.d
		doins "${FILESDIR}"/99-gpsd-usb.rules
		keepdir /var/run/usb # needed for REMOVER
	else
		newconfd "${FILESDIR}"/gpsd.conf gpsd
		newinitd "${FILESDIR}"/gpsd.init gpsd
	fi

	if use X && ! use minimal ; then
		insinto /etc/X11/app-defaults
		newins xgps.ad Xgps
		newins xgpsspeed.ad Xgpsspeed
	else
		rm "${D}usr/share/man/man1/xgpsspeed.1.bz2" \
		"${D}usr/share/man/man1/xgps.1.bz2"
	fi

	diropts "-m0644"
	dobin logextract

	if use python ; then
		exeinto /usr/$(get_libdir)/python${PYVER}/site-packages
		doexe gps.py gpsfake.py gpspacket.so
	fi

	if use minimal; then
		doman gpsctl.1 gpsflash.1 gpspipe.1 gpsd.8 gps.1
		use python && doman gpsprof.1 gpsfake.1 gpscat.1
	fi

	dodoc INSTALL README TODO

	# add missing include file (see bug #162361)
	insinto /usr/include
	doins gpsd_config.h
}

pkg_postinst() {
	elog ""
	elog "This version of gpsd has broken the support for the TNT compass"
	elog "and Garmin so they are disabled.  If you need it, stay with the"
	elog "previous version for now.  The minimal flag now removes X and"
	elog "enables the embedded device (ie, small footprint) support, but"
	elog "you'll need to modify the ebuild if you need to change either"
	elog "the number of clients or the number of devices.  Although pps"
	elog "is enabled, it still needs the correct kernel patches.  All"
	elog "recent versions of udev (>=udev-115 or so) should have correct"
	elog "usb device detection and startup of gpsd (ie, without hotplug)."
	elog ""
	elog "Different GPS devices require the corresponding kernel options"
	elog "to be enabled, such as USB_SERIAL_GARMIN, or a USB serial driver"
	elog "for an adapter such as those that come with Deluo GPS units (eg,"
	elog "USB_SERIAL_PL2303). Straight serial devices should always work,"
	elog "even without udev/hotplug support."
	elog ""
	elog "Note: the supplied gpsd udev rules are now device-specific, so"
	elog "if your device isn't detected correctly, please use lsusb or"
	elog "another suitable tool to determine the proper device IDs and"
	elog "use the commented rules to fill in the blanks for your device."
	elog "Please file a bug to get your device added to the list."
	elog ""
	elog "Read the INSTALL doc for more information on supported hardware,"
	elog "and make sure udev has the right group permissions set on the tty"
	elog "devices if using USB (it should Do The Right Thing (TM))..."
	elog ""
}
