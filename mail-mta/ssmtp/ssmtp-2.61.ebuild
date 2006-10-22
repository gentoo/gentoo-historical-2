# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/ssmtp/ssmtp-2.61.ebuild,v 1.17 2006/10/22 00:37:52 ticho Exp $

inherit eutils

DESCRIPTION="Extremely simple MTA to get mail off the system to a Mailhub"
HOMEPAGE="ftp://ftp.debian.org/debian/pool/main/s/ssmtp/"
SRC_URI="mirror://debian/pool/main/s/ssmtp/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ssl ipv6 md5sum mailwrapper"

DEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"
RDEPEND="mailwrapper? ( >=net-mail/mailwrapper-0.2 )
	!mailwrapper? ( !virtual/mta )
	net-mail/mailbase
	ssl? ( dev-libs/openssl )"
PROVIDE="virtual/mta"

S=${WORKDIR}/ssmtp-2.61

src_compile() {
	# Respect LDFLAGS (bug #152197)
	sed -i -e 's:$(CC) -o:$(CC) @LDFLAGS@ -o:' Makefile.in

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
	dosbin ssmtp || die
	fperms 755 /usr/sbin/ssmtp
	dosym /usr/sbin/sendmail /usr/bin/mailq
	dosym /usr/sbin/sendmail /usr/bin/newaliases
	# Removed symlink due to conflict with mailx
	# See bug #7448
	#dosym /usr/sbin/ssmtp /usr/bin/mail
	#The sendmail symlink is now handled by mailwrapper if used
	use mailwrapper || \
		dosym /usr/sbin/ssmtp /usr/sbin/sendmail
	dosym /usr/sbin/sendmail /usr/lib/sendmail
	doman ssmtp.8
	#removing the sendmail.8 symlink to support multiple installed mtas.
	#dosym /usr/share/man/man8/ssmtp.8 /usr/share/man/man8/sendmail.8
	dodoc INSTALL README TLS CHANGELOG_OLD
	dodoc debian/{README.debian,changelog}
	newdoc ssmtp.lsm DESC
	insinto /etc/ssmtp
	doins ssmtp.conf revaliases
	if use mailwrapper
	then
		insinto /etc/mail
		doins ${FILESDIR}/mailer.conf
	fi

	# Set up config file
	# See bug #22658
	#local conffile="/etc/ssmtp/ssmtp.conf"
	#local hostname=`hostname -f`
	#local domainname=`hostname -d`
	#mv ${conffile} ${conffile}.orig
	#sed -e "s:rewriteDomain=:rewriteDomain=${domainname}:g" \
	#        -e "s:_HOSTNAME_:${hostname}:" \
	#        -e "s:^mailhub=mail:mailhub=mail.${domainname}:g" \
	#        ${conffile}.orig > ${conffile}.pre
	#if use ssl;
	#then
	#        sed -e "s:^#UseTLS=YES:UseTLS=YES:g" \
	#                ${conffile}.pre > ${conffile}
	#        mv ${conffile}.pre ${conffile}.orig
	#else
	#        mv ${conffile}.pre ${conffile}
	#fi

	# set up config file, v2. Bug 47562
	local conffile="${D}/etc/ssmtp/ssmtp.conf"
	mv "${conffile}" "${conffile}.orig"
	# Sorry about the weird indentation, I couldn't figure out a cleverer way
	# to do this without having horribly >80 char lines.
	sed -e "s:^hostname=:\n# Gentoo bug #47562\\
# Commenting the following line will force ssmtp to figure\\
# out the hostname itself.\n\\
# hostname=:" \
		"${conffile}.orig" > "${conffile}" \
		|| die "sed failed"
}

pkg_postinst() {
	if ! use mailwrapper && [[ -e /etc/mailer.conf ]]
	then
		einfo
		einfo "Since you emerged ssmtp w/o mailwrapper in USE,"
		einfo "you probably want to 'emerge -C mailwrapper' now."
		einfo
	fi
}
