# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/speakup/speakup-3.0.4.ebuild,v 1.2 2009/05/31 23:36:16 williamh Exp $

inherit linux-mod

DESCRIPTION="The speakup linux kernel based screen reader."
HOMEPAGE="http://linux-speakup.org"
SRC_URI="ftp://linux-speakup.org/pub/speakup/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup() {
	linux-mod_pkg_setup
	case ${KV_EXTRA} in
		*gentoo)
			if kernel_is lt 2 6 25; then
				die "Speakup requires at least gentoo-sources-2.6.25"
			fi
			;;
		*)
			if kernel_is lt 2 6 26; then
				die "Speakup requires at least kernel version2.6.26"
			fi
			;;
	esac

	MODULE_NAMES="speakup(${PN}:\"${S}\"/src)
		speakup_acntpc(${PN}:\"${S}\"/src)
		speakup_acntsa(${PN}:\"${S}\"/src)
		speakup_apollo(${PN}:\"${S}\"/src)
		speakup_audptr(${PN}:\"${S}\"/src)
		speakup_bns(${PN}:\"${S}\"/src)
		speakup_decext(${PN}:\"${S}\"/src)
		speakup_decpc(${PN}:\"${S}\"/src)
		speakup_dectlk(${PN}:\"${S}\"/src)
		speakup_dtlk(${PN}:\"${S}\"/src)
		speakup_dummy(${PN}:\"${S}\"/src)
		speakup_keypc(${PN}:\"${S}\"/src)
		speakup_ltlk(${PN}:\"${S}\"/src)
		speakup_soft(${PN}:\"${S}\"/src)
		speakup_spkout(${PN}:\"${S}\"/src)
		speakup_txprt(${PN}:\"${S}\"/src)"
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
	BUILD_TARGETS="clean all"
}

src_install() {
	linux-mod_src_install
	dodoc Bugs.txt README To-Do doc/DefaultKeyAssignments doc/spkguide.txt
	docinto contrib
	dodoc contrib/*
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "You must set up the speech synthesizer driver to be loaded"
	elog "automatically in order for your system to start speaking"
	elog "when it is booted."
	if has_version "<sys-apps/baselayout-2"; then
		elog "this is done via /etc/modules.autoload.d/kernel-2.6"
	else
		elog "This is done via /etc/conf.d/modules."
	fi
}
