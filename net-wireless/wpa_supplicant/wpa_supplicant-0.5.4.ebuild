# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wpa_supplicant/wpa_supplicant-0.5.4.ebuild,v 1.10 2006/09/05 16:00:17 uberlord Exp $

inherit eutils linux-info toolchain-funcs

DESCRIPTION="IEEE 802.1X/WPA supplicant for secure wireless transfers"
HOMEPAGE="http://hostap.epitest.fi/wpa_supplicant/"
SRC_URI="http://hostap.epitest.fi/releases/${P}.tar.gz"
LICENSE="|| ( GPL-2 BSD )"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus gsm madwifi qt3 qt4 readline ssl kernel_linux kernel_FreeBSD"

RDEPEND="dbus? ( sys-apps/dbus )
		gsm? ( sys-apps/pcsc-lite )
		qt4? ( =x11-libs/qt-4* )
		!qt4? ( qt3? ( =x11-libs/qt-3* ) )
		readline? ( sys-libs/ncurses sys-libs/readline )
		ssl? ( dev-libs/openssl )
		kernel_linux? ( madwifi? ( || ( net-wireless/madwifi-ng net-wireless/madwifi-old ) ) )
		!kernel_linux? ( net-libs/libpcap )"
DEPEND="sys-apps/sed
		${RDEPEND}"

pkg_setup() {
	if use qt3 && use qt4; then
		einfo "You have USE=\"qt3 qt4\" selected, defaulting to USE=\"qt4\""
	fi

	if use kernel_linux ; then
		CONFIG_CHECK="PACKET"
		ERROR_PACKET="${P} requires support for Packet Socket (CONFIG_PACKET)."
		linux-info_pkg_setup
	fi
}

src_unpack() {
	local CONFIG="${S}/.config"

	unpack ${A}

	# net/bpf.h needed for net-libs/libpcap on Gentoo FreeBSD
	sed -i \
		-e "s:\(#include <pcap\.h>\):#include <net/bpf.h>\n\1:" \
		"${S}"/l2_packet_freebsd.c

	# toolchain setup
	echo "CC = $(tc-getCC)" > "${CONFIG}"

	# basic setup
	echo "CONFIG_CTRL_IFACE=y" >> "${CONFIG}"
	echo "CONFIG_BACKEND=file" >> "${CONFIG}"

	# basic authentication methods
	echo "CONFIG_EAP_GTC=y"         >> "${CONFIG}"
	echo "CONFIG_EAP_MD5=y"         >> "${CONFIG}"
	echo "CONFIG_EAP_OTP=y"         >> "${CONFIG}"
	echo "CONFIG_EAP_PAX=y"         >> "${CONFIG}"
	echo "CONFIG_EAP_PSK=y"         >> "${CONFIG}"
	echo "CONFIG_EAP_TLV=y"         >> "${CONFIG}"
	echo "CONFIG_IEEE8021X_EAPOL=y" >> "${CONFIG}"
	echo "CONFIG_PKCS12=y"          >> "${CONFIG}"
	echo "CONFIG_PEERKEY=y"         >> "${CONFIG}"

	if use dbus; then
		echo "CONFIG_CTRL_IFACE_DBUS=y" >> "${CONFIG}"
	fi

	if use gsm; then
		# smart card authentication
		echo "CONFIG_EAP_SIM=y" >> "${CONFIG}"
		echo "CONFIG_EAP_AKA=y" >> "${CONFIG}"
		echo "CONFIG_PCSC=y"    >> "${CONFIG}"
	fi

	if use readline; then
		# readline/history support for wpa_cli
		echo "CONFIG_READLINE=y" >> "${CONFIG}"
	fi

	if use ssl; then
		# SSL authentication methods
		echo "CONFIG_EAP_LEAP=y"     >> "${CONFIG}"
		echo "CONFIG_EAP_MSCHAPV2=y" >> "${CONFIG}"
		echo "CONFIG_EAP_PEAP=y"     >> "${CONFIG}"
		echo "CONFIG_EAP_TLS=y"      >> "${CONFIG}"
		echo "CONFIG_EAP_TTLS=y"     >> "${CONFIG}"
		echo "CONFIG_SMARTCARD=y"    >> "${CONFIG}"
	fi

	if use kernel_linux; then
		# Linux specific drivers
		echo "CONFIG_DRIVER_ATMEL=y"       >> "${CONFIG}"
		echo "CONFIG_DRIVER_HOSTAP=y"      >> "${CONFIG}"
		echo "CONFIG_DRIVER_IPW=y"         >> "${CONFIG}"
		echo "CONFIG_DRIVER_NDISWRAPPER=y" >> "${CONFIG}"
		echo "CONFIG_DRIVER_PRISM54=y"     >> "${CONFIG}"
		echo "CONFIG_DRIVER_WEXT=y"        >> "${CONFIG}"
		echo "CONFIG_DRIVER_WIRED=y"       >> "${CONFIG}"

		if use madwifi; then
			# Add include path for madwifi-driver headers
			echo "CFLAGS += -I${ROOT}/usr/include/madwifi" >> "${CONFIG}"
			echo "CONFIG_DRIVER_MADWIFI=y"                 >> "${CONFIG}"
		fi
	fi

	if use kernel_FreeBSD; then
		# FreeBSD specific driver
		echo "CONFIG_DRIVER_BSD=y" >> "${CONFIG}"
	fi

	# people seem to take the example configuration file too literally
	# bug #102361
	sed -i \
		-e "s:^\(opensc_engine_path\):#\1:" \
		-e "s:^\(pkcs11_engine_path\):#\1:" \
		-e "s:^\(pkcs11_module_path\):#\1:" \
		${S}/wpa_supplicant.conf || die

	# Change configuration to match Gentoo locations, #143750
	sed -i \
		-e "s:/usr/lib/opensc:/usr/$(get_libdir):" \
		-e "s:/usr/lib/pkcs11:/usr/$(get_libdir):" \
		"${S}"/wpa_supplicant.conf || die
}

src_compile() {
	emake || die "emake failed"

	if use qt4; then
		qmake -o "${S}"/wpa_gui-qt4/Makefile "${S}"/wpa_gui-qt4/wpa_gui.pro
		cd "${S}"/wpa_gui-qt4
		emake || die "emake wpa_gui-qt4 failed"
	elif use qt3; then
		[[ -d ${QTDIR}/etc/settings ]] && addwrite "${QTDIR}"/etc/settings
		/usr/qt/3/bin/qmake -o "${S}"/wpa_gui/Makefile "${S}"/wpa_gui/wpa_gui.pro
		cd "${S}"/wpa_gui
		emake || die "emake wpa_gui failed"
	fi
}

src_install() {
	into /
	dosbin wpa_supplicant
	dobin wpa_cli wpa_passphrase

	exeinto /etc/wpa_supplicant/
	newexe "${FILESDIR}"/wpa_cli.sh wpa_cli.sh

	# compatibility symlink for =baselayout-1.11*
	dosym /etc/wpa_supplicant/wpa_cli.sh /sbin/wpa_cli.action

	if use qt4; then
		into /usr
		dobin wpa_gui-qt4/wpa_gui
	elif use qt3; then
		into /usr
		dobin wpa_gui/wpa_gui
	fi

	if use qt3 || use qt4; then
		make_desktop_entry wpa_gui "WPA_Supplicant Administration GUI"
	fi

	dodoc ChangeLog COPYING eap_testing.txt README todo.txt
	newdoc wpa_supplicant.conf wpa_supplicant.conf.example

	doman doc/docbook/*.8
	doman doc/docbook/*.5
}

pkg_postinst() {
	einfo "To use ${MY_P} you must create the configuration file"
	einfo "/etc/wpa_supplicant/wpa_supplicant.conf"
	einfo
	einfo "An example configuration file is available as"
	einfo "/usr/share/doc/${PF}/wpa_supplicant.conf.example.gz"
	if use madwifi; then
		einfo
		einfo "This package now compiles against the headers installed by"
		einfo "the madwifi driver. You should reemerge ${PN} after"
		einfo "upgrading your madwifi driver."
	fi
}
