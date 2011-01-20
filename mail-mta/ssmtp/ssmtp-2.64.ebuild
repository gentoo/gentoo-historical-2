# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/ssmtp/ssmtp-2.64.ebuild,v 1.2 2011/01/20 01:07:27 flameeyes Exp $

EAPI="3"

PATCHES=2

WANT_AUTOMAKE=none

inherit eutils autotools

DESCRIPTION="Extremely simple MTA to get mail off the system to a Mailhub"
HOMEPAGE="ftp://ftp.debian.org/debian/pool/main/s/ssmtp/"
SRC_URI="mirror://debian/pool/main/s/ssmtp/${P/-/_}.orig.tar.bz2
	http://dev.gentoo.org/~flameeyes/ssmtp/${P}-patches-${PATCHES}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="ipv6 ssl gnutls"

DEPEND="ssl? (
		!gnutls? ( dev-libs/openssl )
		gnutls? ( net-libs/gnutls )
	)"
RDEPEND="${DEPEND}
	net-mail/mailbase
	!net-mail/mailwrapper
	!virtual/mta"
PROVIDE="virtual/mta"

pkg_setup() {
	enewgroup ssmtp
}

src_prepare() {
	EPATCH_SUFFIX="patch" EPATCH_SOURCE="${WORKDIR}/patches" \
		epatch

	eautoconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/ssmtp \
		$(use_enable ssl) $(use_with gnutls) \
		$(use_enable ipv6 inet6) \
		--enable-md5auth
}

src_compile() {
	emake etcdir="${EPREFIX}"/etc || die
}

src_install() {
	dosbin ssmtp || die

	doman ssmtp.8 ssmtp.conf.5 || die
	dodoc INSTALL README TLS CHANGELOG_OLD || die
	newdoc ssmtp.lsm DESC || die

	insinto /etc/ssmtp
	doins ssmtp.conf revaliases || die

	local conffile="${ED}etc/ssmtp/ssmtp.conf"

	# Sorry about the weird indentation, I couldn't figure out a cleverer way
	# to do this without having horribly >80 char lines.
	sed -i -e "s:^hostname=:\n# Gentoo bug #47562\\
# Commenting the following line will force ssmtp to figure\\
# out the hostname itself.\n\\
# hostname=:" \
		"${conffile}" || die "sed failed"

	# Comment rewriteDomain (bug #243364)
	sed -i -e "s:^rewriteDomain=:#rewriteDomain=:" "${conffile}"

	# Set restrictive perms on ssmtp.conf as per #187841, #239197
	# Protect the ssmtp configfile from being readable by regular users as it
	# may contain login/password data to auth against a the mailhub used.
	fowners root:ssmtp /etc/ssmtp/ssmtp.conf
	fperms 640 /etc/ssmtp/ssmtp.conf

	fowners root:ssmtp /usr/sbin/ssmtp
	fperms 2711 /usr/sbin/ssmtp

	dosym ../sbin/ssmtp /usr/lib/sendmail || die
	dosym ../sbin/ssmtp /usr/bin/sendmail || die
	dosym ssmtp /usr/sbin/sendmail || die
	dosym ../sbin/ssmtp /usr/bin/mailq || die
	dosym ../sbin/ssmtp /usr/bin/newaliases || die
}
