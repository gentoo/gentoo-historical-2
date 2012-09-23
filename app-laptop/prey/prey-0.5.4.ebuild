# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/prey/prey-0.5.4.ebuild,v 1.2 2012/09/23 08:13:24 phajdan.jr Exp $

EAPI=4

inherit eutils user

DESCRIPTION="Tracking software for asset recovery"
HOMEPAGE="http://preyproject.com/"
SRC_URI="http://preyproject.com/releases/${PV}/${P}-linux.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="gtk userpriv"

LINGUAS="en it sv es"
for x in ${LINGUAS}; do
	IUSE="${IUSE} linguas_${x}"
done

MODULES="+alarm +alert +geo lock +network secure +session webcam"
IUSE="${IUSE} ${MODULES}"

DEPEND=""
#TODO: some of these deps may be dependent on USE
RDEPEND="${DEPEND}
	app-shells/bash
	virtual/cron
	|| ( net-misc/curl net-misc/wget )
	dev-perl/IO-Socket-SSL
	dev-perl/Net-SSLeay
	sys-apps/net-tools
	alarm? ( media-sound/mpg123
			 media-sound/pulseaudio
		   )
	alert? ( || ( ( gnome-extra/zenity ) ( kde-base/kdialog ) ) )
	gtk? ( dev-python/pygtk )
	lock? ( dev-python/pygtk )
	network? ( net-analyzer/traceroute )
	session? ( sys-apps/iproute2
			   || ( media-gfx/scrot media-gfx/imagemagick )
			 )
	webcam? ( || ( ( media-video/mplayer[encode,jpeg,v4l] ) ( media-tv/xawtv ) ) )"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use userpriv; then
		enewgroup ${PN}
	fi
	if use gtk; then
		ewarn "You have the 'gtk' useflag enabled"
		ewarn "This means that the ${PN} configuration"
		ewarn "will be accessible via a graphical user"
		ewarn "interface. This may allow the thief to alter"
		ewarn "or disable the ${PN} functionality"
	fi

	# remove system module since it depends on hal and we don't
	# have hal in portage anymore
	rm -rf "${S}"/modules/system || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cron-functions.patch \
		"${FILESDIR}"/${P}-gtk-ui.patch \
		"${FILESDIR}"/${PN}-0.5.3-mplayer-support.patch
	sed -i -e 's,readonly base_path=`dirname "$0"`,readonly \
		base_path="/usr/share/prey",' \
		"${S}"/prey.sh || die
}

src_install() {
	# Remove config app if -gtk
	if use gtk; then
		# fix the path
		doicon "${S}"/pixmaps/${PN}.png
		newbin "${S}"/platform/linux/${PN}-config.py ${PN}-config
		make_desktop_entry ${PN}-config "Prey Configuration" ${PN} \
			"System;Monitor"
	else
		rm -f "${S}"/platform/linux/prey-config.py || die
	fi

	# clear out unneeded language files
	for lang in ${LINGUAS}; do
		use "linguas_${lang}" || rm -f lang/${lang} modules/*/lang/${lang}
	done

	# Core files
	insinto /usr/share/prey
	doins -r "${S}"/core "${S}"/lang "${S}"/pixmaps "${S}"/platform "${S}"/version

	# Main script
	newbin ${PN}.sh ${PN}

	# Put the configuration file into /etc, strict perms, symlink
	insinto /etc/prey
	newins config ${PN}.conf
	# some scripts require /usr/share/prey/config file to be present
	# so symlink it to prey.conf
	dosym /etc/${PN}/${PN}.conf /usr/share/${PN}/config
	use userpriv && { fowners root:${PN} /etc/prey ; }
	fperms 770 /etc/prey
	use userpriv && { fowners root:${PN} /etc/prey/prey.conf ; }
	fperms 660 /etc/prey/prey.conf

	# Add cron.d script
	insinto /etc/cron.d
	doins "${FILESDIR}/prey.cron"
	use userpriv && { fowners root:${PN} /etc/cron.d/prey.cron ; }
	fperms 660 /etc/cron.d/prey.cron

	dodoc README

	# modules
	cd "${S}"/modules
	for mod in *
	do
		use ${mod} || continue

		# move config, if present, to /etc/prey
		if [ -f $mod/config ]
		then
			insinto "/etc/prey"
			newins "$mod/config" "mod-$mod.conf"
			use userpriv && { fowners root:${PN} "/etc/${PN}/mod-$mod.conf" ; }
			fperms 660 "/etc/${PN}/mod-$mod.conf"
			# Rest of the module in its expected location
			insinto /usr/share/prey/modules
			doins -r "$mod"
			if [[ $mod == "lock" ]]; then
				fperms 555 \
					"/usr/share/${PN}/modules/lock/platform/linux/${PN}-lock"
			fi
		fi
	done

}
pkg_postinst () {
	elog "--Configuration--"
	elog "Make sure you follow the next steps before running prey for the"
	elog "first time"
	if use userpriv; then
		elog "- Add your user to ${PN} group using"
		elog "gpasswd -a <your_user> ${PN}"
	else
		elog "You don't seem to have 'userpriv' enabled so"
		elog "${PN} configuration is only accessible as root"
	fi
	elog "- Create an account on http://preyproject.com/"
	elog "- Modify the core and module configuration in /etc/prey"
	elog "- Uncomment the line in /etc/cron.d/prey.cron"
}
