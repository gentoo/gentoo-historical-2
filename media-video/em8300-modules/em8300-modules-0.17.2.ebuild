# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/em8300-modules/em8300-modules-0.17.2.ebuild,v 1.2 2009/06/12 19:26:56 zzam Exp $

inherit eutils linux-mod

MY_P="${P/-modules/}"

DESCRIPTION="em8300 (RealMagic Hollywood+/Creative DXR3) video decoder card kernel modules"
HOMEPAGE="http://dxr3.sourceforge.net"
SRC_URI="mirror://sourceforge/dxr3/${MY_P}.tar.gz"

DEPEND="virtual/linux-sources"
RDEPEND=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CONFIG_CHECK="I2C_ALGOBIT"
MODULE_NAMES="em8300(video:) bt865(video:) adv717x(video:)"

S="${WORKDIR}/${MY_P}/modules"

src_unpack() {
	unpack ${A}
	cd "${S}/.."
	epatch "${FILESDIR}/${P}-kernel-2.6.30.patch"
}

src_compile() {
	set_arch_to_kernel
	cd "${S}"
	emake KERNEL_LOCATION="${KERNEL_DIR}" || die "emake failed."
}

src_install() {
	linux-mod_src_install

	dodoc README-modoptions README-modules.conf

	newsbin devices.sh em8300-devices.sh

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/modules.em8300 em8300

	insinto /etc/udev/rules.d
	newins em8300-udev.rules 15-em8300.rules
}

pkg_preinst() {
	linux-mod_pkg_preinst

	local old="${ROOT}/etc/modules.d/em8300"
	local new="${ROOT}/etc/modprobe.d/em8300"

	if [[ -a ${old} && ! -a ${new} ]]; then
		elog "Moving old em8300 configuration in /etc/modules.d to new"
		elog "location in /etc/modprobe.d"
		mv "${old}" "${new}"
	fi
}
