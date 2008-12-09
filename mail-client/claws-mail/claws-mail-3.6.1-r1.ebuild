# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail/claws-mail-3.6.1-r1.ebuild,v 1.3 2008/12/09 18:26:16 ssuominen Exp $

EAPI=1

inherit eutils multilib

DESCRIPTION="An email client (and news reader) based on GTK+"
HOMEPAGE="http://www.claws-mail.org/"

SRC_URI="mirror://sourceforge/sylpheed-claws/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="bogofilter crypt dillo doc gnome gnutls imap ipv6 kde ldap nntp pda
session smime spamassassin -spell ssl startup-notification xface"

COMMONDEPEND=">=x11-libs/gtk+-2.6
	pda? ( >=app-pda/jpilot-0.99 )
	ssl? ( net-libs/gnutls )
	ldap? ( >=net-nds/openldap-2.0.7 )
	crypt? ( >=app-crypt/gpgme-1.1.1 )
	dillo? ( www-client/dillo )
	spell? ( >=app-text/enchant-1.0.0 )
	kde? ( kde-base/kdelibs )
	imap? ( >=net-libs/libetpan-0.57 )
	nntp? ( >=net-libs/libetpan-0.57 )
	gnome? ( >=gnome-base/libgnomeprintui-2.2 )
	gnutls? ( net-libs/gnutls )
	startup-notification? ( x11-libs/startup-notification )
	bogofilter? ( mail-filter/bogofilter )
	session? ( x11-libs/libSM
			x11-libs/libICE )
	smime? ( >=app-crypt/gpgme-1.1.1 )"

DEPEND="${COMMONDEPEND}
	xface? ( >=media-libs/compface-1.4 )
	dev-util/pkgconfig"

RDEPEND="${COMMONDEPEND}
	app-misc/mime-types
	x11-misc/shared-mime-info"

PLUGIN_NAMES="acpi-notifier att-remover attachwarner cachesaver etpan-privacy fetchinfo gtkhtml maildir mailmbox newmail notification pdf-viewer perl rssyl smime synce vcalendar"
pkg_setup() {
	# rework with EAPI=2
	if use spell; then
		if ! built_with_use app-text/enchant aspell; then
			eerror
			eerror "You need to rebuild app-text/enchant with USE=aspell enabled"
			eerror
			die "please rebuild app-text/enchant with USE=aspell"
		fi
	fi
}

src_compile() {
	local myconf="--disable-libetpan"

	# libetpan is needed if user wants nntp or imap functionality
	use imap && myconf="--enable-libetpan"
	use nntp && myconf="--enable-libetpan"

	econf \
		$(use_enable gnome gnomeprint) \
		$(use_enable ipv6) \
		$(use_enable ldap) \
		$(use_enable pda jpilot) \
		$(use_enable spell enchant) \
		$(use_enable gnutls) \
		$(use_enable ssl gnutls) \
		$(use_enable xface compface) \
		$(use_enable doc manual) \
		$(use_enable startup-notification) \
		$(use_enable session libsm) \
		$(use_enable crypt pgpmime-plugin) \
		$(use_enable crypt pgpinline-plugin) \
		$(use_enable crypt pgpcore-plugin) \
		$(use_enable dillo dillo-viewer-plugin) \
		$(use_enable spamassassin spamassassin-plugin) \
		$(use_enable bogofilter bogofilter-plugin) \
		$(use_enable smime smime-plugin) \
		--enable-trayicon-plugin \
		--disable-maemo ${myconf} || die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	# Makefile install claws-mail.png in /usr/share/icons/hicolor/48x48/apps
	# => also install it in /usr/share/pixmaps for other desktop envs
	# => also install higher resolution icons in /usr/share/icons/hicolor/...
	insinto /usr/share/pixmaps
	doins ${PN}.png || die
	local res resdir
	for res in 64x64 128x128 ; do
		resdir="/usr/share/icons/hicolor/${res}/apps"
		insinto ${resdir}
		newins ${PN}-${res}.png ${PN}.png || die
	done

	dodoc AUTHORS ChangeLog* INSTALL* NEWS README* TODO*
	docinto tools
	dodoc tools/README*

	insinto /usr/share/applications
	doins ${PN}.desktop

	einfo "Installing extra tools"
	cd "${S}"/tools
	exeinto /usr/$(get_libdir)/${PN}/tools
	doexe *.pl *.py *.conf *.sh || die
	doexe tb2claws-mail update-po uudec uuooffice || die

	if use kde; then
		einfo "Installing kde service scripts"
		local kdeprefix="$(kde-config --prefix)"
		local servicescript="${PN}-kdeservicemenu.pl"
		local desktopfile="${PN}-attach-files.desktop"
		cd "${S}"/tools/kdeservicemenu
		sed -i -e "s:SCRIPT_PATH:${kdeprefix}/bin/${servicescript}:g" \
			${desktopfile}.template
		dodir /usr/share/apps/konqueror/servicemenus
		insopts -m 0644
		insinto /usr/share/apps/konqueror/servicemenus
		newins ${desktopfile}.template ${desktopfile} || die
		dodir ${kdeprefix}/bin
		insopts -m 755
		exeinto ${kdeprefix}/bin
		doexe ${servicescript} || die
	fi

	# kill useless plugin files
	rm -f "${D}"/usr/lib*/${PN}/plugins/*.{la,a}
}

pkg_postinst() {
	gtk-update-icon-cache -f -t "${ROOT}"/usr/share/icons/hicolor

	UPDATE_PLUGINS=""
	RENAME_PLUGINS=""
	for x in ${PLUGIN_NAMES}; do
		has_version mail-client/${PN}-$x && UPDATE_PLUGINS="${UPDATE_PLUGINS} $x"
		has_version mail-client/sylpheed-claws-$x && RENAME_PLUGINS="${RENAME_PLUGINS} $x"
	done
	if [ -n "${RENAME_PLUGINS}" ]; then
		elog
		elog "The following sylpheed-claws plugins were found on your system:"
		elog
		for x in ${RENAME_PLUGINS}; do
			elog "    mail-client/sylpheed-claws-$x"
		done
		elog
		elog "If you want to continue using those you need to merge their "
		elog "renamed counterparts:"
		elog
		for x in ${RENAME_PLUGINS}; do
			elog "    mail-client/${PN}-$x"
		done
		elog
	fi
	if [ -n "${UPDATE_PLUGINS}" ]; then
		elog
		elog "You have to re-emerge or update the following plugins:"
		elog
		for x in ${UPDATE_PLUGINS}; do
			elog "    mail-client/${PN}-$x"
		done
		elog
	fi
	if [ -n "${RENAME_PLUGINS}${UPDATE_PLUGINS}" ]; then
		elog
		elog "You can use"
		elog "    /bin/bash ${FILESDIR}/plugins-rebuild.sh"
		elog "to automatically handle this."
		elog
		epause 5
		ebeep 3
	fi
}

pkg_postrm() {
	gtk-update-icon-cache -f -t "${ROOT}"/usr/share/icons/hicolor
}
