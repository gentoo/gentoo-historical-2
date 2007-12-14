# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nx/nx-3.1.0.ebuild,v 1.1 2007/12/14 14:25:53 voyageur Exp $

inherit autotools eutils multilib

DESCRIPTION="NX compression technology core libraries"
HOMEPAGE="http://www.nomachine.com/developers.php"

URI_BASE="http://web04.nomachine.com/download/${PV}/sources"
SRC_NX_X11="nx-X11-$PV-1.tar.gz"
SRC_NXAGENT="nxagent-$PV-2.tar.gz"
SRC_NXAUTH="nxauth-$PV-1.tar.gz"
SRC_NXCOMP="nxcomp-$PV-4.tar.gz"
SRC_NXCOMPEXT="nxcompext-$PV-2.tar.gz"
SRC_NXCOMPSHAD="nxcompshad-$PV-2.tar.gz"
SRC_NXPROXY="nxproxy-$PV-2.tar.gz"

SRC_URI="$URI_BASE/$SRC_NX_X11 $URI_BASE/$SRC_NXAGENT $URI_BASE/$SRC_NXPROXY $URI_BASE/$SRC_NXAUTH $URI_BASE/$SRC_NXCOMPEXT $URI_BASE/$SRC_NXCOMPSHAD $URI_BASE/$SRC_NXCOMP"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rdesktop vnc"

RDEPEND="x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXtst
	>=media-libs/jpeg-6b-r4
	>=media-libs/libpng-1.2.8
	>=sys-libs/zlib-1.2.3
	rdesktop? ( net-misc/rdesktop )
	vnc? ( || ( net-misc/vnc net-misc/tightvnc ) )"

DEPEND="${RDEPEND}
		x11-misc/gccmakedep
		x11-misc/imake"

S=${WORKDIR}/${PN}-X11

pkg_setup() {
	if use vnc; then
		if has_version net-misc/vnc && ! built_with_use net-misc/vnc server;
		then
			die "net-misc/vnc needs to be built with USE=\"server\" for VNC support"
		fi

		if has_version net-misc/tightvnc && ! built_with_use net-misc/tightvnc server;
		then
			die "net-misc/tightvnc needs to be built with USE=\"server\" for VNC support"
		fi
	fi
}

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}"
	epatch "${FILESDIR}"/1.5.0/nx-x11-1.5.0-tmp-exec.patch
	epatch "${FILESDIR}"/1.5.0/nxcomp-1.5.0-pic.patch

	cd "${WORKDIR}"/nxcomp
	epatch "${FILESDIR}"/${PN}-2.1.0-deprecated-headers.patch
	epatch "${FILESDIR}"/${PN}-2.1.0-invalid-options.patch
	eautoreconf
}

src_compile() {
	cd "${WORKDIR}"/nxcomp || die "No nxcomp directory found"
	econf || die "nxcomp econf failed"
	emake || die "nxcomp emake failed"

	cd "${WORKDIR}"/nxcompshad || die "No nxcompshad directory found"

	econf || die "nxcompshad econf failed"
	emake || die "nxcompshad emake failed"

	cd "${WORKDIR}"/nxproxy || die "No nxproxy directory found"
	econf || die "nxproxy econf failed"
	emake || die "nxproxy emake failed"

	cd "${S}" || die "No nx-X11 directory found"
	emake World || die "nx-X11 emake failed"

	cd "${WORKDIR}"/nxcompext || die "No nxcompext directory found"
	econf || die "nxcompext econf failed"
	emake || die "nxcompext emake failed"
}

src_install() {
	NX_ROOT=/usr/$(get_libdir)/NX

	for x in nxagent nxauth nxproxy; do
		make_wrapper $x ./$x ${NX_ROOT}/bin ${NX_ROOT}/$(get_libdir) ||
			die " $x wrapper creation failed"
	done

	into ${NX_ROOT}
	dobin "${S}"/programs/Xserver/nxagent
	dobin "${S}"/programs/nxauth/nxauth
	dobin "${WORKDIR}"/nxproxy/nxproxy

	dolib.so "${S}"/lib/X11/libX11.so*
	dolib.so "${S}"/lib/Xext/libXext.so*
	dolib.so "${S}"/lib/Xrender/libXrender.so*
	dolib.so "${WORKDIR}"/nxcomp/libXcomp.so*
	dolib.so "${WORKDIR}"/nxcompext/libXcompext.so*
	dolib.so "${WORKDIR}"/nxcompshad/libXcompshad.so*
}
