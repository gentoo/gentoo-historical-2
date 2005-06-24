# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/hsfmodem/hsfmodem-7.18.00.05.ebuild,v 1.2 2005/06/24 05:26:35 mrness Exp $

inherit eutils

#The document is the same as in hcfpcimodem, even if it has a different URL
MY_DOC="100498D_RM_HxF_Released.pdf"

DESCRIPTION="Linuxant's modem driver for Conexant HSF chipset"
HOMEPAGE="http://www.linuxant.com/drivers/hsf/index.php"
SRC_URI="x86? ( http://www.linuxant.com/drivers/hsf/full/archive/${P}full/${P}full.tar.gz )
	amd64? ( http://www.linuxant.com/drivers/hsf/full/archive/${P}x86_64full/${P}x86_64full.tar.gz )
	doc? ( http://www.linuxant.com/drivers/hsf/full/archive/${P}full/${MY_DOC} )"

LICENSE="Conexant"
KEYWORDS="-* ~x86 ~amd64"
IUSE="doc"
SLOT="0"

DEPEND="virtual/libc
	dev-lang/perl
	app-arch/cpio"

S="${WORKDIR}"

pkg_setup() {
	if useq x86; then
		MY_ARCH_S=${S}/${P}full
	elif useq amd64; then
		MY_ARCH_S=${S}/${P}x86_64full
	fi
}

src_compile() {
	cd ${MY_ARCH_S}
	emake all || die "make failed"
}

src_install () {
	cd ${MY_ARCH_S}
	make PREFIX=${D}/usr/ ROOT=${D} install || die "make install failed"

	use doc && dodoc "${DISTDIR}/${MY_DOC}"
}

pkg_preinst() {
	local NVMDIR="${ROOT}/etc/${PN}/nvm"
	if [ -d "${NVMDIR}" ]; then
		einfo "Cleaning ${NVMDIR}..."
		rm -rf "${NVMDIR}"
		eend
	fi
}

pkg_postinst() {
	einfo "To complete the installation and configuration of your HSF modem,"
	einfo "please run hsfconfig."
}
