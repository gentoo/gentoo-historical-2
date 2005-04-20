# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-utils/bluez-utils-2.10-r1.ebuild,v 1.5 2005/04/20 21:37:29 hansmi Exp $

IUSE="gtk"

inherit eutils

DESCRIPTION="bluetooth utilities"
HOMEPAGE="http://bluez.sourceforge.net/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND=">=net-wireless/bluez-libs-2.10
	!net-wireless/bluez-pan
	gtk? ( >=dev-python/pygtk-2.2 )
	dev-libs/libusb"

DEPEND="sys-devel/bison
	sys-devel/flex
	>=sys-apps/sed-4
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S};

	# Fix some installation locations
	for dir in rfcomm sdpd pand hcid dund tools; do
		mv -f $dir/Makefile.in ${T}/Makefile.in
		sed -e "s:\$(prefix)/usr/share/man:\@mandir\@:" \
			${T}/Makefile.in > $dir/Makefile.in;
	done

	mv -f hcid/Makefile.in ${T}/Makefile.in
	sed -e "s:\$(prefix)/etc/bluetooth:/etc/bluetooth:" \
		${T}/Makefile.in > hcid/Makefile.in

	epatch ${FILESDIR}/${P}-handsfree.patch

	if ! use gtk; then
		mv -f scripts/Makefile.in ${T}/Makefile.in
		sed -e "s:= bluepin:= :" \
			${T}/Makefile.in > scripts/Makefile.in
	fi
}

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README

	sed -e "s:security auto;:security user;:" \
		-i ${D}/etc/bluetooth/hcid.conf

	if use gtk; then
		sed -e "s:\(pin_helper \).*:\1/usr/bin/bluepin;:" \
			-i ${D}/etc/bluetooth/hcid.conf
	else
		sed -e "s:\(pin_helper \).*:\1/etc/bluetooth/pin-helper;:" \
			-i ${D}/etc/bluetooth/hcid.conf
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/2.10-r1/bluetooth.rc bluetooth

	exeinto /etc/bluetooth
	newexe ${FILESDIR}/2.10-r1/pin-helper.sh pin-helper
	insinto /etc/bluetooth
	newins ${FILESDIR}/2.10-r1/pin pin
	fperms 0600 /etc/bluetooth/pin

	insinto /etc/conf.d
	newins ${S}/scripts/bluetooth.default bluetooth
	sed -i -e 's/^HIDD_ENABLE=.*/HIDD_ENABLE=false/' \
		-e 's/^HID2HCI_ENABLE=.*/HID2HCI_ENABLE=false/' \
		${D}/etc/conf.d/bluetooth
}

pkg_postinst() {
	einfo ""
	einfo "A startup script has been installed in /etc/init.d/bluetooth."
	einfo "RFComm devices are found in /dev/bluetooth/rfcomm/* instead of /dev/rfcomm*"
	einfo "If you need to set a default PIN, edit /etc/bluetooth/pin, and change"
	einfo "/etc/bluetooth/hcid.conf option 'pin_helper' to /etc/bluetooth/pin-helper."

	if use gtk; then
		einfo "By default, /usr/bin/bluepin will be launched on the desktop display"
		einfo "for pin number input."
	fi
	einfo ""
}
