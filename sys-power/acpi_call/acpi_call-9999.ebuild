# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/acpi_call/acpi_call-9999.ebuild,v 1.1 2011/06/10 05:46:52 maksbotan Exp $

EAPI=3

EGIT_REPO_URI="git://github.com/mkottman/acpi_call.git"

inherit git linux-info linux-mod

DESCRIPTION="A kernel module that enables you to call ACPI methods"
HOMEPAGE="http://github.com/mkottman/acpi_call"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"
BUILD_TARGETS="clean default"

src_compile(){
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}
