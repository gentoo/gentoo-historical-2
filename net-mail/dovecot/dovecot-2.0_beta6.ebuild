# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/dovecot/dovecot-2.0_beta6.ebuild,v 1.1 2010/06/15 21:23:33 patrick Exp $

EAPI="2"

inherit eutils versionator ssl-cert

MY_P="${P/_/.}"
major_minor="$( get_version_component_range 1-2 )"
sieve_snapshot="b877a1db00a5"
SRC_URI="http://dovecot.org/releases/${major_minor}/beta/${MY_P}.tar.gz
	sieve? (
	http://hg.rename-it.nl/dovecot-2.0-pigeonhole/archive/${sieve_snapshot}.tar.gz
	) "
DESCRIPTION="An IMAP and POP3 server written with security primarily in mind"
HOMEPAGE="http://www.dovecot.org/"

SLOT="0"
LICENSE="LGPL-2.1" # MIT too?
KEYWORDS="~alpha ~amd64 ~arm ~sparc ~x86"

IUSE="berkdb bzip2 caps cydir dbox doc ipv6 kerberos ldap +maildir managesieve mbox mysql pam postgres sieve sqlite +ssl suid vpopmail zlib"

DEPEND="berkdb? ( sys-libs/db )
	caps? ( sys-libs/libcap )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	pam? ( virtual/pam )
	postgres? ( virtual/postgresql-base )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	vpopmail? ( net-mail/vpopmail )"

RDEPEND="${DEPEND}
	>=net-mail/mailbase-0.00-r8"

pkg_setup() {
	if use managesieve && ! use sieve; then
		eerror "managesieve USE flag selected but sieve USE flag unselected"
		die "USE flag problem"
	fi

	if use dbox && ! use maildir; then
		eerror "dbox USE flag needs maildir USE flag enabled"
		die "USE flag problem"
	fi

	# Add user and group for login process (same as for fedora/redhat)
	# default internal user
	enewgroup dovecot 97
	enewuser dovecot 97 -1 /dev/null dovecot
	# add "mail" group for suid'ing. Better security isolation.
	if use suid; then
		enewgroup mail
	fi
	# default login user
	enewuser dovenull -1 -1 /dev/null
}

src_configure() {
	local conf=""

	if use postgres || use mysql || use sqlite; then
		conf="${conf} --with-sql"
	fi

	local storages=""
	for storage in cydir dbox maildir mbox; do
		use ${storage} && storages="${storage} ${storages}"
	done
	[ "${storages}" ] || storages="maildir"

	cd ${MY_P}
	econf \
		--localstatedir=/var \
		--with-moduledir="/usr/$( get_libdir )/dovecot" \
		$( use_with bzip2 bzlib ) \
		$( use_with caps libcap ) \
		$( use_with kerberos gssapi ) \
		$( use_with ldap ) \
		$( use_with mysql ) \
		$( use_with pam ) \
		$( use_with postgres pgsql ) \
		$( use_with sqlite ) \
		$( use_with ssl ) \
		$( use_with vpopmail ) \
		$( use_with zlib ) \
		--with-storages="${storages}" \
		--disable-rpath \
		${conf}

	if use sieve; then
		# The sieve plugin needs this file to be build to determine the plugin
		# directory and the list of libraries to link to.
		emake dovecot-config || die "emake dovecot-config failed"

		# snapshot. should not be necessary for 2.0 release
		cd "$(find ../ -type d -name dovecot-2-0-pigeonhole*)" || die "cd failed"
		./autogen.sh || die "autogen failed"

		econf \
			--localstatedir=/var \
			--enable-shared \
			--with-dovecot="../${MY_P}" \
			$( use_with managesieve )
	fi
}

src_compile() {
	cd "${MY_P}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "make failed"

	if use sieve; then
		cd "$(find ../ -type d -name dovecot-2-0-pigeonhole*)" || die "cd failed"
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "make sieve failed"
	fi
}

src_install () {
	cd "${MY_P}"
	emake DESTDIR="${D}" install || die "make install failed"

	# insecure:
	# use suid && fperms u+s /usr/libexec/dovecot/deliver
	# better:
	if use suid;then
		einfo "Changing perms to allow deliver to be suided"
		fowners root:mail "${D}"/usr/libexec/dovecot/deliver
		fperms 4750 "${D}"/usr/libexec/dovecot/deliver
	fi

	newinitd "${FILESDIR}"/dovecot.init-r2 dovecot

	rm -rf "${D}"/usr/share/doc/dovecot
	rm -rf "${D}"/usr/share/aclocal

	dodoc AUTHORS NEWS README TODO || die "basic dodoc failed"
	rm -f doc/Makefile*
	dodoc doc/* || die "dodoc doc failed"
	docinto example-config
	dodoc doc/example-config/*.{conf,ext} || die "dodoc example failed"
	docinto example-config/conf.d
	dodoc doc/example-config/conf.d/*.{conf,ext} || die "dodoc conf.d failed"
	docinto wiki
	dodoc doc/wiki/* || die "dodoc wiki failed"

	# Create the dovecot.conf file from the dovecot-example.conf file that
	# the dovecot folks nicely left for us....
	local conf="${D}/etc/dovecot/dovecot.conf"
	local confd="${D}/etc/dovecot/conf.d"

	insinto /etc/dovecot
	doins doc/example-config/*.{conf,ext}
	insinto /etc/dovecot/conf.d
	doins doc/example-config/conf.d/*.{conf,ext}
	fperms 0600 /etc/dovecot/dovecot-{ldap,sql}.conf.ext
	sed -i -e "s:/usr/share/doc/dovecot/:/usr/share/doc/${PF}/:" \
	"${confd}/../README" || die "sed failed"

	# .maildir is the Gentoo default, but we need to support mbox too
	local mail_location="maildir:~/.maildir"
	if use mbox; then
		mail_location="mbox:/var/spool/mail/%u:INDEX=/var/dovecot/%u"
		keepdir /var/dovecot
		sed -i -e 's|#mail_privileged_group =|mail_privileged_group = mail|' \
		"${confd}/10-mail.conf" || die "sed failed"
	fi
	sed -i -e \
		"s|#mail_location =|mail_location = ${mail_location}|" \
		"${confd}/10-mail.conf" \
		|| die "failed to update mail location settings in 10-mail.conf"

	# We're using pam files (imap and pop3) provided by mailbase
	if use pam; then
		sed -i -e '/driver = pam/,/^[ \t]*}/ s|#args = dovecot|args = "\*"|' \
			"${confd}/auth-system.conf.ext" \
			|| die "failed to update PAM settings in auth-system.conf.ext"
		# mailbase does not provide a managesieve pam file
		use managesieve && dosym imap /etc/pam.d/managesieve
		sed -i -e \
			's/#!include auth-system.conf.ext/!include auth-system.conf.ext/' \
			"${confd}/10-auth.conf" \
			|| die "failed to update PAM settings in 10-auth.conf"
	fi

	# Disable ipv6 if necessary
	if ! use ipv6; then
		sed -i -e 's/^#listen = \*, ::/listen = \*/g' "${conf}" \
			|| die "failed to update listen settings in dovecot.conf"
	fi

	# Update ssl cert locations
	if use ssl; then
		sed -i -e 's:^#ssl = yes:ssl = yes:' "${confd}/10-ssl.conf" \
		|| die "ssl conf failed"
		sed -i -e 's:^ssl_cert =.*:ssl_cert = </etc/ssl/dovecot/server.pem:' \
			-e 's:^ssl_key =.*:ssl_key = </etc/ssl/dovecot/server.key:' \
			"${confd}/10-ssl.conf" || die "failed to update SSL settings in 10-ssl.conf"
	fi

	# Install SQL configuration
	if use mysql || use postgres; then
		sed -i -e \
			's/#!include auth-sql.conf.ext/!include auth-sql.conf.ext/' \
			"${confd}/10-auth.conf" || die "failed to update SQL settings in \
			10-auth.conf"
	fi

	# Install LDAP configuration
	if use ldap; then
		sed -i -e \
			's/#!include auth-ldap.conf.ext/!include auth-ldap.conf.ext/' \
			"${confd}/10-auth.conf" \
			|| die "failed to update ldap settings in 10-auth.conf"
	fi

	if use vpopmail; then
		sed -i -e \
			's/#!include auth-vpopmail.conf.ext/!include auth-vpopmail.conf.ext/' \
			"${confd}/10-auth.conf" \
			|| die "failed to update vpopmail settings in 10-auth.conf"
	fi

	if use sieve; then
		cd "$(find ../ -type d -name dovecot-2-0-pigeonhole*)" || die "cd failed"
		emake DESTDIR="${D}" install || die "make install failed (sieve)"
		sed -i -e \
			's/^[[:space:]]*#mail_plugins =/mail_plugins = sieve/' "${confd}/15-lda.conf" \
			|| die "failed to update sieve settings in 15-lda.conf"
		rm -rf "${D}"/usr/share/doc/dovecot
		dodoc doc/*.txt
		docinto example-config/conf.d
		dodoc doc/example-config/conf.d/*.conf
		insinto /etc/dovecot/conf.d
		doins doc/example-config/conf.d/90-sieve.conf
		use managesieve && doins doc/example-config/conf.d/20-managesieve.conf
		docinto sieve/rfc
		dodoc doc/rfc/*.txt
		docinto sieve/devel
		dodoc doc/devel/DESIGN
	fi

}

pkg_preinst() {

	has_version =${CATEGORY}/${PN}-0*
	dovecot_upgrade_from_0_x=$?

	has_version =${CATEGORY}/${PN}-1*
	dovecot_upgrade_from_1_x=$?

	if [[ $dovecot_upgrade_from_0_x = 0 ]] ; then
		elog "There are a lot of changes in configuration files.  Please read"
		elog "http://wiki.dovecot.org/Upgrading and edit the conf files"
		elog "in ${ROOT}etc/dovecot"
	elif [[ $dovecot_upgrade_from_1_x = 0 ]] ; then
		elog "There are a lot of changes in configuration files in dovecot-2.0."
		elog "Please check the conf files in ${ROOT}etc/dovecot."
		elog "You can run doveconf -n before running etc-update or"
		elog "dispatch-conf to get an idea about what needs to be changed."
		ewarn "Do not {re}start dovecot without checking your conf files"
		ewarn "and making the necessary changes."
	fi

}

pkg_postinst() {

	if use ssl; then
	# Let's not make a new certificate if we already have one
		if ! [[ -e "${ROOT}"/etc/ssl/dovecot/server.pem && \
		-e "${ROOT}"/etc/ssl/dovecot/server.key ]];	then
			einfo "Creating SSL	certificate"
			SSL_ORGANIZATION="${SSL_ORGANIZATION:-Dovecot IMAP Server}"
			install_cert /etc/ssl/dovecot/server
		fi
	fi

}
