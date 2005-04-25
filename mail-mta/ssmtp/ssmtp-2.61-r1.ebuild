# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/ssmtp/ssmtp-2.61-r1.ebuild,v 1.1 2005/04/25 20:36:38 ferdy Exp $

inherit eutils mailer

DESCRIPTION="Extremely simple MTA to get mail off the system to a Mailhub"
HOMEPAGE="ftp://ftp.debian.org/debian/pool/main/s/ssmtp/"
SRC_URI="ftp://ftp.debian.org/debian/pool/main/s/ssmtp/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="ssl ipv6 md5sum"

DEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/ssmtp-2.61

src_compile() {
	econf \
		--sysconfdir=/etc/ssmtp \
		$(use_enable ssl) \
		$(use_enable ipv6 inet6) \
		$(use_enable md5sum md5auth) \
		|| die
	make clean || die
	make etcdir=/etc || die
}

src_install() {
	dodir /usr/bin /usr/sbin /usr/lib
	dosbin ssmtp
	chmod 755 ${D}/usr/sbin/ssmtp

	doman ssmtp.8
	dodoc COPYING INSTALL README TLS CHANGELOG_OLD
	newdoc ssmtp.lsm DESC

	insinto /etc/ssmtp
	doins ssmtp.conf revaliases

	local conffile="${D}/etc/ssmtp/ssmtp.conf"
	mv "${conffile}" "${conffile}.orig"

	# Sorry about the weird indentation, I couldn't figure out a cleverer way
	# to do this without having horribly >80 char lines.
	sed -e "s:^hostname=:\n# Gentoo bug #47562\\
# Commenting the following line will force ssmtp to figure\\
# out the hostname itself.\n\\
# hostname=:" "${conffile}.orig" \
		> "${conffile}" \
		|| die "sed failed"

	if use mailwrapper ; then
		dosym /usr/sbin/ssmtp /usr/bin/sendmail.ssmtp
		dosym /usr/sbin/ssmtp /usr/bin/mailq.ssmtp
		dosym /usr/sbin/ssmtp /usr/bin/newaliases.ssmtp
		mailer_install_conf
	else
		dosym /usr/sbin/ssmtp /usr/sbin/sendmail
		dosym /usr/sbin/ssmtp /usr/lib/sendmail
		dosym /usr/sbin/ssmtp /usr/bin/sendmail
		dosym /usr/sbin/ssmtp /usr/sbin/mailq
		dosym /usr/sbin/ssmtp /usr/sbin/newaliases
	fi
}
