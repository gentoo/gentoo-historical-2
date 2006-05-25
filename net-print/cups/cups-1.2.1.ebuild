# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups/cups-1.2.1.ebuild,v 1.1 2006/05/25 09:59:55 genstef Exp $

inherit eutils pam flag-o-matic multilib autotools

MY_P=${P/_/}

DESCRIPTION="The Common Unix Printing System"
HOMEPAGE="http://www.cups.org/"
SRC_URI="http://ftp.easysw.com/pub/cups/${PV}/${MY_P}-source.tar.bz2"
#ESVN_REPO_URI="http://svn.easysw.com/public/cups/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ssl slp pam samba nls gnutls dbus"

DEP="pam? ( virtual/pam )
	ssl? (
		!gnutls? ( >=dev-libs/openssl-0.9.6b )
		gnutls? ( net-libs/gnutls )
		)
	slp? ( >=net-libs/openslp-1.0.4 )
	dbus? ( sys-apps/dbus )
	>=media-libs/libpng-1.2.1
	>=media-libs/tiff-3.5.5
	>=media-libs/jpeg-6b
	app-text/libpaper"
DEPEND="${DEP}
	nls? ( sys-devel/gettext )"
RDEPEND="${DEP}
	nls? ( virtual/libintl )
	!virtual/lpr
	>=app-text/poppler-0.4.3-r1"
PDEPEND="samba? ( >=net-fs/samba-3.0.8 )"
PROVIDE="virtual/lpr"

# upstream includes an interactive test which is a nono for gentoo.
# therefore, since the printing herd has bigger fish to fry, for now,
# we just leave it out, even if FEATURES=test
RESTRICT="test"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup lp
	enewuser lp -1 -1 -1 lp

	enewgroup lpadmin
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/cups-1.2.0-bindnow.patch

	# cups does not use autotools "the usual way" and ship a static config.h.in
	eaclocal
	eautoconf
}

src_compile() {
	local myconf

	use ssl && \
		myconf="${myconf} $(use_enable gnutls) $(use_enable !gnutls openssl)"

	export DSOFLAGS="${LDFLAGS}"
	econf \
		--with-cups-user=lp \
		--with-cups-group=lp \
		--with-system-groups=lpadmin \
		--localstatedir=/var \
		--with-bindnow=$(bindnow-flags) \
		$(use_enable pam) \
		$(use_enable ssl) \
		$(use_enable slp) \
		$(use_enable nls) \
		$(use_enable dbus) \
		--enable-libpaper \
		--enable-threads \
		--enable-static \
		--disable-pdftops \
		${myconf} \
		|| die "econf failed"

	# Install in /usr/libexec always, instead of using /usr/lib/cups, as that
	# makes more sense when facing multilib support.
	sed -i -e 's:SERVERBIN.*:SERVERBIN = $(BUILDROOT)/usr/libexec/cups:' Makedefs
	sed -i -e 's:#define CUPS_SERVERBIN.*:#define CUPS_SERVERBIN "/usr/libexec/cups":' config.h
	sed -i -e 's:cups_serverbin=.*:cups_serverbin=/usr/libexec/cups:' cups-config

	emake || die "emake failed"
}

src_install() {
	make BUILDROOT=${D} install || die "make install failed"

	dodoc {CHANGES,CREDITS,LICENSE,README}.txt
	dosym /usr/share/cups/docs /usr/share/doc/${PF}/html

	# cleanups
	rm -rf ${D}/etc/init.d ${D}/etc/pam.d ${D}/etc/rc* ${D}/usr/share/man/cat*

	pamd_mimic_system cups auth account

	sed -i -e "s:server = .*:server = /usr/libexec/cups/daemon/cups-lpd:" ${D}/etc/xinetd.d/cups-lpd

	# install pdftops filter
	exeinto /usr/libexec/cups/filter/
	newexe ${FILESDIR}/pdftops.pl pdftops

	fowners lp:lp /var/log/cups /var/run/cups/certs /var/cache/cups \
		/var/spool/cups/tmp /var/spool/cups /etc/cups/{,interfaces,ppd}
	keepdir /var/log/cups /var/run/cups/certs /var/cache/cups /var/spool/cups/tmp
}

pkg_preinst() {
	# cleanups
	[ -n "${PN}" ] && rm -fR /usr/share/doc/${PN}-*
}

pkg_postinst() {
	einfo "Remote printing: change "
	echo "Listen localhost:631"
	einfo "to"
	echo "Listen *:631"
	einfo "in /etc/cups/cupsd.conf"
	einfo
	einfo "For more information about installing a printer take a look at:"
	einfo "http://www.gentoo.org/doc/en/printing-howto.xml."
	einfo
	einfo "You need to emerge ghostscript with the cups-USEflag turned on"
}
