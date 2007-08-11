# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-2.10.2.ebuild,v 1.10 2007/08/11 15:00:05 ticho Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.9"
inherit eutils flag-o-matic alternatives gnome2 autotools

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://www.gnome.org/projects/evolution/"
SRC_URI="${SRC_URI}
	bogofilter? ( mirror://gentoo/${PN}-2.5.5.1-bf-junk.tar.bz2 )"

LICENSE="GPL-2 FDL-1.1"
SLOT="2.0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
# gstreamer for audio-inline, when it uses 0.10
IUSE="bogofilter crypt dbus debug doc hal ipv6 kerberos krb4 ldap mono nntp pda profile spell ssl"

# Pango dependency required to avoid font rendering problems
RDEPEND=">=x11-themes/gnome-icon-theme-1.2
	dev-libs/atk
	>=gnome-extra/gtkhtml-3.14.0
	>=dev-libs/glib-2.10
	>=gnome-base/orbit-2.9.8
	>=gnome-base/libbonobo-2
	>=gnome-extra/evolution-data-server-1.9.4
	>=gnome-base/libbonoboui-2.4.2
	>=gnome-base/gnome-vfs-2.4
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomecanvas-2
	>=dev-libs/libxml2-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeprint-2.7
	>=gnome-base/libgnomeprintui-2.2.1
	>=x11-libs/gtk+-2
	>=gnome-base/libgnome-2
	>=net-libs/libsoup-2.2.96
	>=x11-libs/pango-1.8.1
	x11-libs/libnotify
	hal? ( >=sys-apps/hal-0.5.4 )
	pda? (
		>=app-pda/gnome-pilot-2
		>=app-pda/gnome-pilot-conduits-2 )
	spell? ( >=app-text/gnome-spell-1.0.5 )
	crypt? ( || ( >=app-crypt/gnupg-2.0.1-r2 =app-crypt/gnupg-1.4* ) )
	ssl? (
		>=dev-libs/nspr-4.6.1
		>=dev-libs/nss-3.11 )
	ldap? ( >=net-nds/openldap-2 )
	kerberos? ( virtual/krb5 )
	krb4? ( virtual/krb5 )
	dbus? ( dev-libs/dbus-glib )
	mono? ( >=dev-lang/mono-1 )
	bogofilter? ( mail-filter/bogofilter )
	!bogofilter? ( mail-filter/spamassassin )"
#	gstreamer? (
#		>=media-libs/gstreamer-0.10
#		>=media-libs/gst-plugins-base-0.10 )

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	sys-devel/bison
	app-text/scrollkeeper
	>=gnome-base/gnome-common-2.12.0
	>=app-text/gnome-doc-utils-0.9.1
	doc? ( >=dev-util/gtk-doc-0.6 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
ELTCONF="--reverse-deps"

pkg_setup() {
	G2CONF="--disable-default-binary \
		--without-kde-applnk-path        \
		$(use_enable ssl nss)            \
		$(use_enable ssl smime)          \
		$(use_enable ipv6)               \
		$(use_enable mono)               \
		$(use_enable nntp)               \
		$(use_enable pda pilot-conduits) \
		$(use_enable profile profiling)  \
		$(use_with ldap openldap)        \
		$(use_with kerberos krb5 /usr)"

	# We need a graphical pinentry frontend to be able to ask for the GPG
	# password from inside evolution, bug 160302
	if use crypt && has_version '>=app-crypt/gnupg-2.0.1-r2'; then
		if ! built_with_use -o app-crypt/pinentry gtk qt3; then
			die "You must build app-crypt/pinentry with GTK or QT3 support"
		fi
	fi

	if use krb4 && ! built_with_use virtual/krb5 krb4; then
		ewarn
		ewarn "In order to add kerberos 4 support, you have to emerge"
		ewarn "virtual/krb5 with the 'krb4' USE flag enabled as well."
		ewarn
		ewarn "Skipping for now."
		ewarn
		G2CONF="${G2CONF} --without-krb4"
	else
		G2CONF="${G2CONF} $(use_with krb4 krb4 /usr)"
	fi

	# Plug-ins to install. Normally we would want something similar to
	# --enable-plugins=all (plugins_base + plugins_standard), except for some
	# special cases.
	local plugins="calendar-file calendar-http calendar-weather \
		itip-formatter plugin-manager default-source addressbook-file \
		startup-wizard print-message mark-all-read groupwise-features \
		groupwise-account-setup hula-account-setup mail-account-disable \
		publish-calendar caldav imap-features \
		bbdb subject-thread save-calendar select-one-source copy-tool \
		mail-to-task mark-calendar-offline mailing-list-actions \
		new-mail-notify default-mailer import-ics-attachments"

	# For dev releases, add experimental plugins
	plugins="${plugins} backup-restore folder-unsubscribe mail-to-meeting \
		prefer-plain save-attachments"

	if use bogofilter; then
		plugins="${plugins} bf-junk-plugin"
	else
		plugins="${plugins} sa-junk-plugin"
	fi

	# The special cases

	# remove this due to bug #128035 re-enable later if it doesn't dep on
	# gstreamer-0.8
	# use gstreamer && plugins="${plugins} audio-inline"
	use dbus && plugins="${plugins} new-mail-notify"
	use mono && plugins="${plugins} mono"

	if built_with_use gnome-extra/evolution-data-server ldap; then
		plugins="${plugins} exchange-operations"
	fi

	local pluginlist=""
	for p in $plugins; do
		[ "x$pluginlist" != "x" ] && pluginlist="${pluginlist},"
		pluginlist="${pluginlist}${p}"
	done

	G2CONF="${G2CONF} --enable-plugins=${pluginlist}"
}

src_unpack() {
	gnome2_src_unpack

	# Accept the list of plugins separated by commas instead of spaces.
	epatch "${FILESDIR}"/${PN}-2.3.7-configure_plugins.patch

	# Fix 64-bit warnings
	epatch "${FILESDIR}"/${PN}-2.8.1.1-64-bit.patch

	# Fix "reply to meeting" buffer overruns
	epatch "${FILESDIR}"/${PN}-2.9.91-cal-reply.patch

	# Add bogofilter junk plugin source
	use bogofilter && epatch "${FILESDIR}"/${PN}-2.9.2-bf-junk.patch.gz

	# certificate filtering for clueless users (and even for those who know)
	epatch ${FILESDIR}/${PN}-2.8.2.1-certificate-manager-filtering.patch

	# Fix timezone offsets on fbsd.  bug #183708
	epatch "${FILESDIR}"/${P}-fbsd.patch

	eautoreconf
}

src_compile() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		sed -i -e "s|mozilla-nss|nss|
			s|mozilla-nspr|nspr|" ${S}/configure
		G2CONF="${G2CONF} --enable-nss=yes"
	else
		G2CONF="${G2CONF} --without-nspr-libs --without-nspr-includes \
			--without-nss-libs --without-nss-includes"
	fi

	# problems with -O3 on gcc-3.3.1
	replace-flags -O3 -O2

	if [ "${ARCH}" = "hppa" ]; then
		append-flags "-fPIC -ffunction-sections"
		export LDFLAGS="-ffunction-sections -Wl,--stub-group-size=25000"
	fi

	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst

	alternatives_auto_makesym "/usr/bin/evolution" "/usr/bin/evolution-[0-9].[0-9][0-9]"
	elog "To change the default browser if you are not using GNOME, do:"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/http/command -t string 'mozilla %s'"
	elog "gconftool-2 --set /desktop/gnome/url-handlers/https/command -t string 'mozilla %s'"
	elog ""
	elog "Replace 'mozilla %s' with which ever browser you use."
}
