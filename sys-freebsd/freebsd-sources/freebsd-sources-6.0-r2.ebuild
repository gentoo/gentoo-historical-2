# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-sources/freebsd-sources-6.0-r2.ebuild,v 1.1 2006/04/03 23:55:54 flameeyes Exp $

inherit bsdmk freebsd

DESCRIPTION="FreeBSD kernel sources"
SLOT="${PVR}"
KEYWORDS="~x86-fbsd"

IUSE="symlink"

SRC_URI="mirror://gentoo/${SYS}.tar.bz2"

RDEPEND=""
DEPEND=""

RESTRICT="nostrip"

S=${WORKDIR}/sys

MY_PVR="${PVR}"

[[ ${MY_PVR} == "${RV}" ]] && MY_PVR="${MY_PVR}-r0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PN}-gentoo.patch"
	epatch "${FILESDIR}/${P}-flex-2.5.31.patch"

	epatch "${FILESDIR}/SA-06-04-ipfw.patch"
	epatch "${FILESDIR}/SA-06-05-80211.patch"
	epatch "${FILESDIR}/SA-06-06-kmem60.patch"
	epatch "${FILESDIR}/SA-06-07-pf.patch"
	epatch "${FILESDIR}/SA-06-11-ipsec.patch"

	sed -i -e "s:%GENTOOPVR%:${PVR}:" conf/newvers.sh
}

src_compile() {
	einfo "Nothing to compile.."
}

src_install() {
	insinto /usr/src/sys-${MY_PVR}
	doins -r ${S}/*
}

pkg_postinst() {
	if [[ ! -L ${ROOT}usr/src/sys ]]; then
		einfo "/usr/src/sys symlink doesn't exist; creating..."
		ln -sf sys-${MY_PVR} ${ROOT}/usr/src/sys || \
			eerror "Couldn't create ${ROOT}/usr/src/sys symlink."
		ln -sf sys-${MY_PVR} ${ROOT}/usr/src/sys-${RV} || \
			eerror "Couldn't create ${ROOT}/usr/src/sys-${RV} symlink."
	elif use symlink; then
		einfo "Updating /usr/src/sys symlink..."
		rm ${ROOT}/usr/src/sys
		ln -sf sys-${MY_PVR} ${ROOT}/usr/src/sys || \
			eerror "Couldn't create ${ROOT}/usr/src/sys symlink."
		ln -sf sys-${MY_PVR} ${ROOT}/usr/src/sys-${RV} || \
			eerror "Couldn't create ${ROOT}/usr/src/sys-${RV} symlink."
	fi
}
