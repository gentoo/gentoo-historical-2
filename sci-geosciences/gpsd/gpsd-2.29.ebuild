# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gpsd/gpsd-2.29.ebuild,v 1.3 2005/10/01 05:51:09 nerdboy Exp $

inherit eutils libtool distutils

DESCRIPTION="GPS daemon and library to support USB/serial GPS devices and various GPS/mapping clients."
HOMEPAGE="http://gpsd.berlios.de/"
SRC_URI="http://download.berlios.de/gpsd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~ppc64 ~sparc ~arm"

IUSE="X usb dbus"

DEPEND="X? ( virtual/motif
		virtual/x11
	)
	usb? ( sys-apps/hotplug )
	dbus? ( ~sys-apps/dbus-0.23.4 )
	dev-lang/python
	app-text/xmlto
	virtual/libc
	sys-devel/gcc"

src_unpack() {
	unpack ${A}
	cd ${S}
	elibtoolize
}

src_compile() {
	distutils_python_version
	export MY_ECONF="--with-gnu-ld --with-pic $(use_with X x) $(use_enable dbus)"
	econf ${MY_ECONF} || die "econf failed"
	emake LDFLAGS="${LDFLAGS} -lm" || die "emake failed"
}

src_install() {
	cd ${S}
	make DESTDIR=${D} install

	if use usb ; then
	    sed -i -e "s/gpsd.hotplug/gpsd/g" gpsd.hotplug gpsd.usermap
	    insinto /etc/hotplug/usb
	    doins gpsd.usermap
	    exeinto /etc/hotplug/usb
	    newexe gpsd.hotplug gpsd
	else
	    newconfd ${FILESDIR}/gpsd.conf gpsd
	    newinitd ${FILESDIR}/gpsd.init gpsd
	fi
	if use X ; then
	    insinto /usr/$(get_libdir)/X11/app-defaults
	    newins xgps.ad Xgps
	    newins xgpsspeed.ad Xgpsspeed
	fi
	dobin logextract
	diropts "-m0644"
	exeinto /usr/$(get_libdir)/python${PYVER}/site-packages
	doexe gps.py gpsfake.py
	dodoc AUTHORS HACKING INSTALL README TODO ${FILESDIR}/40-usb-serial.rules
}

pkg_postinst() {
	einfo "To use hotplugging (USB devices) your kernel has to be compiled"
	einfo "with CONFIG_HOTPLUG enabled and sys-apps/hotplug must be emerged"
	einfo "(both usb and dbus support are optional)."
	einfo
	einfo "Different GPS devices require the corresponding kernel options"
	einfo "to be enabled, such as USB_SERIAL_GARMIN, or a USB serial driver"
	einfo "for an adapter, such as those that come with Deluo GPS units (eg,"
	einfo "USB_SERIAL_PL2303). Straight serial devices should always work,"
	einfo "even without hotplug support."
	ewarn
	ewarn "If your client connection shows no data when gpsd is started via"
	ewarn "the normal hotplug action, then kill the existing gpsd process"
	ewarn "and try starting it directly via something like:"
	ewarn "sudo /usr/sbin/gpsd -p /dev/ttyUSB0"
	ewarn "or whatever your device is. This will verify whether your device"
	ewarn "is working or not."
	ewarn
	einfo "Read the INSTALL doc for more information on supported hardware,"
	einfo "and make sure udev has the right group permissions set on the tty"
	einfo "devices if using USB (it should Do The Right Thing (TM))..."
	einfo
	einfo "Finally, the default gpsd setup looks for /dev/ttyUSB0, in the"
	einfo "case of the USB-serial adapter mentioned above.  Depending on"
	einfo "your default device scheme (ie, udev, devfs, static), you will"
	einfo "need to create a device alias if the default name is different."
	einfo "A udev rule file has been provided with an example rule in the"
	einfo "docs directory.  If the device names are correct, gpsd will"
	einfo "start automatically when the GPS device is plugged in."
}
