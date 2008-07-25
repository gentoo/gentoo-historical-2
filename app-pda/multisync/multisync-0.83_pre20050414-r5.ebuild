# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/multisync/multisync-0.83_pre20050414-r5.ebuild,v 1.1 2008/07/25 19:26:45 carlo Exp $

EAPI=1

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit versionator kde-functions eutils multilib autotools flag-o-matic

CVS_VERSION="${PV/*_pre/}"

DESCRIPTION="Modular sync client which supports an array of plugins."
HOMEPAGE="http://multisync.sourceforge.net/"
SRC_URI="mirror://gentoo/${PN}-${CVS_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="evo irmc nokia6600 ldap bluetooth pda kde gnokii"
# evo		- evolution plugin
# irmc		- bluetooth/irmc/irda plugin ( local )
# pda		- opie plugin				 ( local )
# nokia6600 - support for Nokia 6600	 ( local )
# ldap		- ldap plugin - experimental
# kde		- sync with kaddressbook
# gnokii	- gnokii plugin

RDEPEND=">=gnome-base/libbonobo-2.2
		>=gnome-base/libgnomeui-2.2
		>=gnome-base/libgnome-2.2
		>=dev-libs/glib-2
		>=gnome-base/gconf-2
		>=gnome-base/gnome-vfs-2.2
		>=gnome-base/orbit-2.8.2
		>=dev-libs/openssl-0.9.6j
		evo?  ( mail-client/evolution )
		irmc? ( >=net-wireless/irda-utils-0.9.15
				>=dev-libs/openobex-1
				bluetooth? (	>=net-wireless/bluez-libs-2.7
								>=net-wireless/bluez-utils-2.7 ) )
		pda? ( >=net-misc/curl-7.10.5
				~app-pda/pilot-link-0.11.8 )
		kde? ( || ( kde-base/kaddressbook:3.5 kde-base/kdepim:3.5 ) )
		ldap? ( >=net-nds/openldap-2.3.35-r1
				>=dev-libs/cyrus-sasl-2.1.4 )
		gnokii? ( app-mobilephone/gnokii dev-libs/libvformat )
		nokia6600? ( >=dev-libs/libwbxml-0.9.0 )"

DEPEND="${RDEPEND}
		sys-devel/gettext"

S="${WORKDIR}/${PN}"

make_plugin_list() {
	local evoversion

	PLUGINS="backup_plugin syncml_plugin"
	if use evo
	then
		evoversion="$(best_version mail-client/evolution)"
		# remove prefix
		evoversion=${evoversion//*evolution-}
		# remove revisions
		evoversion=${evoversion//-*}
		# find major
		evoversion=$(get_major_version ${evoversion})

		[[ ${evoversion} -eq 2 ]]	&& PLUGINS="${PLUGINS} evolution2_sync"
		[[ ${evoversion} -eq 1 ]]	&& PLUGINS="${PLUGINS} evolution_sync"
	fi
	use irmc	&& PLUGINS="${PLUGINS} irmc_sync"
	use pda		&& PLUGINS="${PLUGINS} opie_sync palm_sync"
	use ldap	&& PLUGINS="${PLUGINS} ldap_plugin"
	use kde		&& PLUGINS="${PLUGINS} kdepim_plugin"
	use gnokii	&& PLUGINS="${PLUGINS} gnokii_sync"
}

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${PN}-gcc4.patch"
	epatch "${FILESDIR}/${P}-evo2.patch"

	[[ -z "${PLUGINS}" ]] && make_plugin_list

	cd "${S}"
	cp /usr/share/gettext/config.rpath "${S}"
	elibtoolize
	AT_M4DIR="plugins/opie_sync/macros" eautoreconf
	for plugin_dir in ${PLUGINS} backup_plugin syncml_plugin
	do
		cd "${S}"/plugins/${plugin_dir}/
		eautoreconf
	done
}

run_compile() {
	append-flags "${myInc}"
	econf ${myConf} || die "Failed during econf!"
	emake || die "Failed during make!"
}

src_compile() {
	use ldap && append-flags "-DLDAP_DEPRECATED"

	[[ -z "${PLUGINS}" ]] && make_plugin_list

	einfo "Building Multisync with these plugins:"
	for plugin_dir in ${PLUGINS}; do
		einfo "		 ${plugin_dir}"
	done

	cd "${S}"
	if use kde; then
		set-qtdir 3
		set-kdedir 3
		myInc="-I${KDEDIR}/include ${myInc}"
	fi

	use pda && myInc="-I/usr/include/libpisock ${myInc}"
	run_compile;
	for plugin_dir in ${PLUGINS}; do
		einfo "Building ${plugin_dir}"
		cd "${S}/plugins/${plugin_dir}"
		run_compile;
	done
}

src_install() {
	[[ -z "${PLUGINS}" ]] && make_plugin_list

	einstall || die "Multisync install failed!"
	for plugin_dir in ${PLUGINS}; do
		cd "${S}/plugins/${plugin_dir}"
		make install DESTDIR="${D}" libdir="\$(prefix)/$(get_libdir)/${PN}" || die "${plugin_dir} make install failed!"
	done
}

pkg_postinst() {
	echo
	elog "${P} is unmaintained by upstream and deprecated. Use it at your own risk."
	elog "Try using its successor app-pda/multisync-gui."
	echo
}
