# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kyro-kernel/kyro-kernel-2.00.20.516.ebuild,v 1.4 2003/09/07 00:08:13 msterret Exp $

MY_P=powervr-${PV%.*}-${PV#*.*.*.}
S=${WORKDIR}/${MY_P}
DESCRIPTION="XFree86 DRI drivers for the KyroII card"
HOMEPAGE="http://www.powervr.com/"
SRC_URI="http://www.powervr.com/Drivers/Linux/${MY_P}.tgz"

LICENSE="ImaginationTechnologies"
SLOT="${KV}"
KEYWORDS="-* x86"
RESTRICT="nostrip"

DEPEND="virtual/x11
	virtual/linux-sources
	>=sys-apps/portage-1.9.10"
RDEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/mtrr-include-fix.diff
}

src_compile() {
	check_KV
	make || die
}

src_install() {
	insinto /lib/modules/${KV}/drivers/char/drm/
	doins powervr.o

	dolib.so lib*.so
	dolib.a lib*.a

	insinto /usr/X11R6/lib/modules/dri
	doins powervr_dri.so

	insinto /usr/X11R6/lib/modules/drivers
	doins powervr_drv.o

	insinto /etc
	dosin powervr_kyro.ini

	dosym /usr/lib/libPVR2D.so /usr/X11R6/lib/modules/drivers/libPVR2D.so

	dodoc XF86KyroSampleConfig LICENSE.TXT README
}
