# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sane-backends/sane-backends-1.0.20.ebuild,v 1.3 2009/07/08 18:47:16 phosphan Exp $

EAPI="1"

inherit eutils flag-o-matic

# gphoto and v4l are handled by their usual USE flags.
# The pint backend was disabled because I could not get it to compile.
IUSE_SANE_BACKENDS="
	abaton
	agfafocus
	apple
	artec
	artec_eplus48u
	as6e
	avision
	bh
	canon
	canon630u
	canon_dr
	canon_pp
	cardscan
	coolscan
	coolscan2
	coolscan3
	dc25
	dc210
	dc240
	dell1600n_net
	dmc
	epjitsu
	epson
	epson2
	fujitsu
	genesys
	gt68xx
	hp
	hp3500
	hp3900
	hp4200
	hp5400
	hp5590
	hpsj5s
	hpljm1005
	hs2p
	ibm
	leo
	lexmark
	ma1509
	matsushita
	microtek
	microtek2
	mustek
	mustek_pp
	mustek_usb
	mustek_usb2
	nec
	net
	niash
	pie
	pixma
	plustek
	plustek_pp
	qcam
	ricoh
	rts8891
	s9036
	sceptre
	sharp
	sm3600
	sm3840
	snapscan
	sp15c
	st400
	stv680
	tamarack
	teco1
	teco2
	teco3
	test
	u12
	umax
	umax_pp
	umax1220u
	xerox_mfp"

IUSE="avahi usb gphoto2 ipv6 v4l doc sane_backends_nothing"

# Use old SANE_BACKENDS values as defaults for our USE_EXPAND variable
for backend in ${IUSE_SANE_BACKENDS}; do
	IUSE="${IUSE} "
	if [ -z "${SANE_BACKENDS}" ]; then
		IUSE="${IUSE}+"
	else
		for oldbackend in ${SANE_BACKENDS}; do
			if [ "${oldbackend}" == "${backend}" ]; then
				IUSE="${IUSE}+"
			fi
		done
	fi
	IUSE="${IUSE}sane_backends_${backend}"
done

DESCRIPTION="Scanner Access Now Easy - Backends"
HOMEPAGE="http://www.sane-project.org/"

RDEPEND="
	sane_backends_dc210? ( >=media-libs/jpeg-6b )
	sane_backends_dc240? ( >=media-libs/jpeg-6b )
	sane_backends_dell1600n_net? ( >=media-libs/jpeg-6b )
	avahi? ( >=net-dns/avahi-0.6.24 )
	x86? (
		sane_backends_canon_pp? ( sys-libs/libieee1284 )
		sane_backends_hpsj5s? ( sys-libs/libieee1284 )
		sane_backends_mustek_pp? ( sys-libs/libieee1284 )
		)
	amd64? (
		sane_backends_canon_pp? ( sys-libs/libieee1284 )
		sane_backends_hpsj5s? ( sys-libs/libieee1284 )
		sane_backends_mustek_pp? ( sys-libs/libieee1284 )
		)
		usb? ( dev-libs/libusb )
	gphoto2? (
				media-libs/libgphoto2
				>=media-libs/jpeg-6b
			)
	v4l? ( sys-kernel/linux-headers
			arm? ( media-libs/libv4l )
			alpha? ( media-libs/libv4l )
			amd64? ( media-libs/libv4l )
			ppc? ( media-libs/libv4l )
			ppc64? ( media-libs/libv4l )
			x86? ( media-libs/libv4l )
			)"

DEPEND="${RDEPEND}
	doc? (
		virtual/latex-base
		|| ( dev-texlive/texlive-latexextra app-text/tetex app-text/ptex )
	)
	>=sys-apps/sed-4"

# We now use new syntax construct (SUBSYSTEMS!="usb|usb_device)
RDEPEND="${RDEPEND}
	!<sys-fs/udev-114"

# Could not access via ftp on 2006-07-20
SRC_URI="http://alioth.debian.org/frs/download.php/2318/${P}.tar.gz
	ftp://ftp.sane-project.org/pub/sane/${P}/${P}.tar.gz
	ftp://ftp.sane-project.org/pub/sane/old-versions/${P}/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

BACKENDS=""

pkg_setup() {

	ensure_a_backend_is_building

	enewgroup scanner

	use gphoto2 && BACKENDS="gphoto2"
	use v4l && BACKENDS="${BACKENDS} v4l"
	for backend in ${IUSE_SANE_BACKENDS}; do
		if use "sane_backends_${backend}"; then
			BACKENDS="${BACKENDS} ${backend}"
		fi
	done
	IEEE1284_BACKENDS="canon_pp hpsj5s mustek_pp"
	if ! use x86 && ! use amd64; then
		tmp="${IUSE_SANE_BACKENDS}"
		for backend in ${IEEE1284_BACKENDS}; do
			if [[ "${tmp/$backend/}" != "${IUSE_SANE_BACKENDS}" ]]; then
				ewarn "You selected a backend which is disabled because it's not usable in your arch."
			fi
		done
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	cat >> backend/dll.conf.in <<-EOF
	# Add support for the HP-specific backend.  Needs net-print/hplip installed.
	hpaio
	EOF
}

src_compile() {
	append-flags -fno-strict-aliasing

	# if you are using a backend that is not contained in the sane-backends
	# distribution, it can make sense to build just the libs and no backend
	# at all.
	if use sane_backends_nothing; then
		BACKENDS=" "
		elog "You are using sane_backends_nothing - disabling all backends!"
	fi
	if use usb && has_version "=dev-libs/libusb-1*"; then
		myconf="--enable-libusb_1_0 --disable-libusb"
	else
		myconf=$(use_enable usb libusb)
	fi
	if ! use doc; then
		myconf="${myconf} --disable-latex"
	fi
	if use sane_backends_mustek_pp; then
		myconf="${myconf} --enable-parport-directio"
	fi
	SANEI_JPEG="sanei_jpeg.o" SANEI_JPEG_LO="sanei_jpeg.lo" \
	BACKENDS="${BACKENDS}" econf \
		$(use_with gphoto2) \
		$(use_enable ipv6) \
		$(use_enable avahi) \
		${myconf} || die "econf failed"

	emake VARTEXFONTS="${T}/fonts" || die

	if use usb; then
		cd tools/hotplug
		grep -v '^$' libsane.usermap > libsane.usermap.new
		mv libsane.usermap.new libsane.usermap
	fi
}

src_install () {
	make INSTALL_LOCKPATH="" DESTDIR="${D}" install \
		docdir=/usr/share/doc/${PF}
	keepdir /var/lib/lock/sane
	fowners root:scanner /var/lib/lock/sane
	fperms g+w /var/lib/lock/sane
	dodir /etc/env.d
	if use usb; then
		cd tools/hotplug
		insinto /etc/hotplug/usb
		exeinto /etc/hotplug/usb
		doins libsane.usermap
		doexe libusbscanner
		newdoc README README.hotplug
		echo >> "${D}"/etc/env.d/30sane "USB_DEVFS_PATH=/dev/bus/usb"
		cd ../..
	fi
	cd tools/udev
	dodir /etc/udev/rules.d
	insinto /etc/udev/rules.d
	newins libsane.rules 70-libsane.rules
	cd ../..
	dodoc NEWS AUTHORS ChangeLog* README README.linux
	echo "SANE_CONFIG_DIR=/etc/sane.d" >> "${D}"/etc/env.d/30sane
}

ensure_a_backend_is_building() {
	use v4l && return
	use gphoto2 && return
	use sane_backends_nothing && return
	for b in ${IUSE_SANE_BACKENDS}; do
		use "sane_backends_${b}" && return
	done
	eerror "You must specify at least one backend or sane_backends_nothing to build."
	eerror "See \"emerge -pv sane-backends\" for a list."
	die "No backend selected."
}
