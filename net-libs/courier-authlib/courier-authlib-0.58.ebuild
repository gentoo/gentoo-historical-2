# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/courier-authlib/courier-authlib-0.58.ebuild,v 1.17 2008/03/09 23:44:25 ricmm Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils flag-o-matic autotools

DESCRIPTION="courier authentication library"
[ -z "${PV/?.??/}" ] && SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
[ -z "$SRC_URI" ] && SRC_URI="http://www.courier-mta.org/beta/courier-authlib/${P%%_pre}.tar.bz2"
HOMEPAGE="http://www.courier-mta.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="postgres ldap mysql berkdb gdbm pam crypt debug"

RESTRICT="userpriv"

DEPEND="gdbm? ( sys-libs/gdbm )
		!gdbm? ( >=sys-devel/autoconf-2.5 sys-libs/db )
		>=dev-libs/openssl-0.9.6
		pam? ( >=sys-libs/pam-0.75 )
		mysql? ( virtual/mysql )
		ldap? ( >=net-nds/openldap-1.2.11 )
		postgres? ( >=dev-db/postgresql-7.2 )"

RDEPEND="gdbm? ( sys-libs/gdbm )
		!gdbm? ( sys-libs/db )"

S="${WORKDIR}/${P%%_pre}"

pkg_setup() {
	if ! has_version 'dev-tcltk/expect' ; then
		ewarn 'The dev-tcltk/expect package is not installed.'
		ewarn 'Without it, you will not be able to change system login passwords.'
		ewarn 'However non-system authentication modules (LDAP, MySQL, PostgreSQL,'
		ewarn 'and others) will work just fine.'
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s|^chk_file .* |&\${DESTDIR}|g" -i.orig authmigrate.in
	use elibc_uclibc && sed -i -e 's:linux-gnu\*:linux-gnu\*\ \|\ linux-uclibc:' config.sub
	if ! use gdbm ; then
		epatch "${FILESDIR}/${PV}-configure-db4.patch"
	else
		epatch "${FILESDIR}/${PV}-remove-obsolete-macro.patch"
	fi
	sed -i -e'/for dir in/a@@INDENT@@/etc/courier-imap \\' ${S}/authmigrate.in
	sed -i -e'/for dir in/a@@INDENT@@/etc/courier/authlib \\' ${S}/authmigrate.in
	sed -i -e"s|@@INDENT@@|		|g" ${S}/authmigrate.in
	sed -i -e"s|\$sbindir/makeuserdb||g" ${S}/authmigrate.in

	eautoreconf
}

src_compile() {
	filter-flags -fomit-frame-pointer

	local myconf
	myconf="$(use_with pam authpam) $(use_with ldap authldap)"

	if use berkdb; then
		if use gdbm; then
			ewarn "Both gdbm and berkdb selected. Using gdbm."
		else
			myconf="${myconf} --with-db=db"
		fi
	fi
	use gdbm && myconf="${myconf} --with-db=gdbm"

	if has_version 'net-mail/vpopmail' ; then
		myconf="${myconf} --with-authvchkpw --without-authmysql --without-authpgsql"
		use mysql && ewarn "vpopmail found. authmysql will not be built."
		use postgres && ewarn "vpopmail found. authpgsql will not be built."
	else
		myconf="${myconf} --without-authvchkpw $(use_with mysql authmysql) $(use_with postgres authpgsql)"
	fi

	use debug && myconf="${myconf} debug=true"

	einfo "Configuring courier-authlib: ${myconf}"

	econf \
		--sysconfdir=/etc/courier \
		--datadir=/usr/share/courier \
		--libexecdir=/usr/$(get_libdir)/courier \
		--localstatedir=/var/lib/courier \
		--sharedstatedir=/var/lib/courier/com \
		--with-authdaemonvar=/var/lib/courier/authdaemon \
		--with-authshadow \
		--without-redhat \
		--with-mailuser=mail \
		--with-mailgroup=mail \
		--cache-file="${S}/configuring.cache" \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

orderfirst() {
	file="${D}/etc/courier/authlib/${1}" ; option="${2}" ; param="${3}"
	if [ -e "${file}" ] ; then
		orig="$(grep \"^${option}=\" ${file} | cut -d'\"' -f 2)"
		new="${option}=\"${param} `echo ${orig} | sed -e\"s/${param}//g\" -e\"s/  / /g\"`\""
		sed -i -e"s/^${option}=.*$/${new}/" ${file}
	fi
}

finduserdb() {
	for dir in \
		/etc/courier/authlib /etc/courier /etc/courier-imap \
		/usr/lib/courier/etc /usr/lib/courier-imap/etc \
		/usr/local/etc /usr/local/etc/courier /usr/local/courier/etc \
		/usr/local/lib/courier/etc /usr/local/lib/courier-imap/etc \
		/usr/local/share/sqwebmail /usr/local/etc/courier-imap ; do
		if [ -e "$dir/userdb" ]; then
			einfo "found $dir/userdb"
			cp -v $dir/userdb ${D}/etc/courier/authlib/
			chmod go-rwx ${D}/etc/courier/authlib/userdb
			continue
		fi
	done
}

src_install() {
	diropts -o mail -g mail
	dodir /etc/courier
	keepdir /var/lib/courier/authdaemon
	keepdir /etc/courier/authlib
	emake install DESTDIR="${D}" || die "install failed"
	emake install-migrate DESTDIR="${D}" || die "migrate failed"
	[ ! -e "${D}/etc/courier/authlib/userdb" ] && finduserdb
	emake install-configure DESTDIR="${D}" || die "install-configure failed"
	rm -vf ${D}/etc/courier/authlib/*.bak
	chown mail:mail ${D}/etc/courier/authlib/*
	for y in ${D}/etc/courier/authlib/*.dist ; do
		[ ! -e "${y%%.dist}" ] && cp -v ${y} ${y%%.dist}
	done
	use pam && orderfirst authdaemonrc authmodulelist authpam
	use ldap && orderfirst authdaemonrc authmodulelist authldap
	use postgres && orderfirst authdaemonrc authmodulelist authpgsql
	use mysql && orderfirst authdaemonrc authmodulelist authmysql
	dodoc AUTHORS COPYING ChangeLog* INSTALL NEWS README
	dohtml README.html README_authlib.html NEWS.html INSTALL.html README.authdebug.html
	if use mysql; then
		dodoc README.authmysql.myownquery
		dohtml README.authmysql.html
	fi
	use postgres && dohtml README.authpostgres.html README.authmysql.html
	if use ldap; then
		dodoc README.ldap
		dodir /etc/openldap/schema
		cp authldap.schema "${D}/etc/openldap/schema/"
	fi
	doinitd "${FILESDIR}/${PN}" || die "doinitd failed"
}

pkg_postinst() {
	if [ -e /etc/courier/authlib/userdb ]; then
		einfo "running makeuserdb"
		chmod go-rwx /etc/courier/authlib/userdb
		makeuserdb
	fi

	# Suggest cleaning out the following old files
	list="$(find /etc/courier -type f -maxdepth 1 | grep \"^/etc/courier/auth\")"
	if [ ! -z "${list}" ] ; then
		ewarn "Courier authentication files are now in /etc/courier/authlib/"
		elog "The following files are no longer needed and can likely be removed:"
		elog " rm $(echo \"${list}\")"
	fi
}
