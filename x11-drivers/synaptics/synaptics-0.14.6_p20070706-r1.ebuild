# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/synaptics/synaptics-0.14.6_p20070706-r1.ebuild,v 1.1 2008/08/30 22:33:17 calchan Exp $

inherit toolchain-funcs eutils linux-info

IUSE="hal"

DESCRIPTION="Driver for Synaptics touchpads"
HOMEPAGE="http://w1.894.telia.com/~u89404340/touchpad/"
SRC_URI="http://dev.gentoo.org/~calchan/distfiles/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="x11-libs/libXext
	 hal? ( sys-apps/hal )"
DEPEND="${RDEPEND}
	x11-base/xorg-server
	x11-proto/inputproto
	>=sys-apps/sed-4"

evdev-input_check() {
	# Check kernel config for required event interface support (either
	# built-in or as a module. Bug #134309.

	ebegin "Checking kernel config for event device support"
	linux_chkconfig_present INPUT_EVDEV
	eend $?

	if [[ $? -ne 0 ]] ; then
		ewarn "Synaptics driver requires event interface support."
		ewarn "Please enable the event interface in your kernel config."
		ewarn "The option can be found at:"
		ewarn
		ewarn "  Device Drivers"
		ewarn "    Input device support"
		ewarn "      -*- Generic input layer"
		ewarn "        <*> Event interface"
		ewarn
		ewarn "Then rebuild the kernel or install the module."
		epause 5
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	evdev-input_check
}

src_unpack() {
	unpack ${A} ; cd "${S}"

	# Switch up the CC, CFLAGS and LDFLAGS stuff.
	sed -i \
		-e "s:CC = gcc:CC = $(tc-getCC) ${CFLAGS} ${LDFLAGS}:g" \
		-e "/CC = / a\
LD = \$(CC)" \
		-e "s:\$(CDEBUGFLAGS)::g" \
		"${S}"/Makefile

	# Fix grabbing of event devices so it will not stop working together with
	# packages which grab their devices at their own like sys-apps/inputd does.
	epatch "${FILESDIR}"/${P}-fixeventgrab.patch

	epatch "${FILESDIR}"/${P}-input_api.patch

	# Patch the Makefile to install the library as executable. Bug #215323.
	epatch "${FILESDIR}"/synaptics-install-so-exec.patch

	# Fix to handle multiple screens through Xinerama properly. Bug #206614.
	epatch "${FILESDIR}"/synaptics-fix-xinerama.patch

	# Adds configurable polling interval. Patch from Novell. Bug #216679.
	epatch "${FILESDIR}"/${PN}-0.14.6-configurable_polling_interval.patch
}

src_compile() {
	emake || die
}

src_install() {
	make \
		DESTDIR="${D}" \
		PREFIX=/usr \
		MANDIR="${D}"/usr/share/man \
		install || die

	dodoc script/usbmouse script/usbhid alps.patch trouble-shooting.txt
	dodoc COMPATIBILITY FILES INSTALL* NEWS TODO README*

	# Stupid new daemon, didn't work for me because of shm issues
	newinitd "${FILESDIR}"/rc.init syndaemon
	newconfd "${FILESDIR}"/rc.conf syndaemon

	if use hal ; then
		# Have HAL assign this driver to supported touchpads.
		insinto /usr/share/hal/fdi/policy/10osvendor
		doins "${FILESDIR}"/11-x11-synaptics.fdi
	fi
}
