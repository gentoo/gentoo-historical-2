# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-utils/bluez-utils-2.10.ebuild,v 1.3 2004/09/27 01:05:02 lv Exp $

inherit eutils

DESCRIPTION="bluetooth utilities"
HOMEPAGE="http://bluez.sourceforge.net/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ppc amd64"
IUSE="gtk"
RDEPEND=">=net-wireless/bluez-libs-2.10
	!net-wireless/bluez-pan
	gtk? ( >=dev-python/pygtk-2 )
	dev-libs/libusb"

DEPEND="sys-devel/bison
	sys-devel/flex
	>=sys-apps/sed-4
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S};
	#epatch ${FILESDIR}/${PN}-2.3-rfcomm_fflush.patch

	# Fix some installation locations

	for dir in rfcomm sdpd pand hcid dund tools; do
		mv -f $dir/Makefile.in ${T}/Makefile.in
		sed -e "s:\$(prefix)/usr/share/man:\@mandir\@:" \
			${T}/Makefile.in > $dir/Makefile.in;
	done

	mv -f hcid/Makefile.in ${T}/Makefile.in
	sed -e "s:\$(prefix)/etc/bluetooth:/etc/bluetooth:" \
		${T}/Makefile.in > hcid/Makefile.in

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
		sed -e "s:\(pin_helper \).*:\1/etc/bluetooth/pin;:" \
			-i ${D}/etc/bluetooth/hcid.conf
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/bluetooth.rc bluetooth

	exeinto /etc/bluetooth
	newexe ${FILESDIR}/pin.sample pin
	fperms 0700 /etc/bluetooth/pin
}

pkg_postinst() {
	einfo ""
	einfo "A startup script has been installed in /etc/init.d/bluetooth."
	einfo "RFComm devices are found in /dev/bluetooh/rfcomm/* instead of /dev/rfcomm*"
	einfo "If you need to set a default PIN, edit /etc/bluetooth/pin, and change"
	einfo "/etc/bluetooth/hcid.conf option 'pin_helper' to /etc/bluetooth/pin."
	if use gtk; then
		einfo "By default, /usr/bin/bluepin will be launched on the desktop display"
		einfo "for pin number input."
	fi
	einfo ""
}
