# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/iwlwifi/iwlwifi-1.2.22.ebuild,v 1.2 2007/12/12 03:01:04 compnerd Exp $

inherit eutils linux-mod

DESCRIPTION="Intel (R) PRO/Wireless Network Drivers"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/${PN}/downloads/${P//_p/-}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipw3945 ipw4965"

DEPEND="|| ( =virtual/linux-sources-2.6.22* =virtual/linux-sources-2.6.23* )"
RDEPEND="ipw3945? ( =net-wireless/iwl3945-ucode-2.14.1.5 )
		 ipw4965? ( =net-wireless/iwl4965-ucode-4.44.1.18 )
		 !ipw3945? ( !ipw4965? ( =net-wireless/iwl3945-ucode-2.14.1.5 =net-wireless/iwl4965-ucode-4.44.1.18 ) )"

pkg_setup() {
	if kernel_is lt 2 6 22 ; then
		eerror "iwlwifi requires a kernel >=2.6.22."
		eerror "Please set your /usr/src/linux symlink accordingly."
		die "invalid /usr/src/linux symlink"
	else
		CONFIG_CHECK="MAC80211"
	fi

	if kernel_is gt 2 6 23 ; then
		eerror "iwlwifi is included in 2.6.24, this ebuild is not guaranteed to"
		eerror "build against the newer kernel."
		die "invalid /usr/src/linux symlink"
	fi

	BUILD_TARGETS="all"
	BUILD_PARAMS="KSRC=${KV_DIR} M=${S}"

	linux-mod_pkg_setup

	if use ipw3945 ; then
		MODULE_NAMES="iwl3945(net/wireless:${S}/compatible)"
		if ! use ipw4965 ; then
			BUILD_PARAMS="${BUILD_PARAMS} CONFIG_IWL4965=n"
		fi
	fi

	if use ipw4965 ; then
		MODULE_NAMES="${MODULE_NAMES} iwl4965(net/wireless:${S}/compatible)"
		if ! use ipw3945 ; then
			BUILD_PARAMS="${BUILD_PARAMS} CONFIG_IWL3945=n"
		fi
	fi

	if ! use ipw3945 && ! use ipw4965 ; then
		einfo "Wireless card not selected, building all modules"
		MODULE_NAMES="iwl3945(net/wireless:${S}/compatible) iwl4965(net/wireless:${S}/compatible)"
		BUILD_PARAMS="${BUILD_PARAMS} CONFIG_IWL3945=m CONFIG_IWL4965=m"
	fi
}
