# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/amavisd-new/amavisd-new-0.20040701.ebuild,v 1.1 2005/01/19 19:10:46 langthang Exp $

inherit eutils

MY_PV=${PV/0./}
DESCRIPTION="High-performance interface between the MTA and content checkers."
HOMEPAGE="http://www.ijs.si/software/amavisd/"
SRC_URI="http://www.ijs.si/software/amavisd/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64 ~sparc ~alpha ~ppc64"
IUSE="ldap mysql postgres milter"

DEPEND=">=sys-apps/sed-4
	>=dev-lang/perl-5.8.2"

RDEPEND="${DEPEND}
	>=sys-apps/coreutils-5.0-r3
	app-arch/gzip
	app-arch/bzip2
	app-arch/arc
	app-arch/cabextract
	app-arch/freeze
	app-arch/lha
	app-arch/unarj
	app-arch/unrar
	app-arch/zoo
	dev-perl/Archive-Tar
	dev-perl/Archive-Zip
	dev-perl/Compress-Zlib
	dev-perl/Convert-TNEF
	dev-perl/Convert-UUlib
	dev-perl/MIME-Base64
	>=dev-perl/MIME-tools-5.413
	>=dev-perl/MailTools-1.58
	dev-perl/net-server
	dev-perl/libnet
	dev-perl/Digest-MD5
	dev-perl/IO-stringy
	>=dev-perl/Time-HiRes-1.49
	dev-perl/Unix-Syslog
	>=sys-libs/db-3.1
	dev-perl/BerkeleyDB
	virtual/mta
	virtual/antivirus
	ldap? ( dev-perl/perl-ldap )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	milter? ( >=mail-mta/sendmail-8.12 )"

S="${WORKDIR}/${PN}-${MY_PV}"

AMAVIS_ROOT=/var/amavis

src_unpack() {
	unpack ${A}
	cd ${S}
	if $(has_version mail-mta/courier) ; then
		einfo "Patching with courier support."
		epatch "amavisd-new-courier.patch" || die "patch failed"
	fi
}

src_compile() {
	if use milter ; then
		cd "${S}/helper-progs"

		econf --with-runtime-dir=${AMAVIS_ROOT} \
			--with-sockname=${AMAVIS_ROOT}/amavisd.sock \
			--with-user=amavis || die "helper-progs econf failed"
		emake || die "helper-progs compile problem"

		cd "${S}"
	fi
}

src_install() {
	enewgroup amavis
	enewuser amavis -1 /bin/false ${AMAVIS_ROOT} amavis

	dosbin amavisd

	insinto /etc
	doins ${FILESDIR}/amavisd.conf
	dosed "s:^#\\?\\\$MYHOME[^;]*;:\$MYHOME = '$AMAVIS_ROOT';:" \
		/etc/amavisd.conf
	if [ "$(domainname)" = "(none)" ] ; then
		dosed "s:^#\\?\\\$mydomain[^;]*;:\$mydomain = '$(hostname)';:" \
			/etc/amavisd.conf
	else
		dosed "s:^#\\?\\\$mydomain[^;]*;:\$mydomain = '$(domainname)';:" \
			/etc/amavisd.conf
	fi
	if ! `has_version mail-filter/spamassassin` ; then
		einfo "Disabling anti-spam code in amavisd.conf..."

		dosed "s:^#[\t ]*@bypass_spam_checks_maps[\t ]*=[\t ]*(1);:\@bypass_spam_checks_maps = (1);:" \
			/etc/amavisd.conf
	fi

	exeinto /etc/init.d
	newexe "${FILESDIR}/amavisd.rc6" amavisd
	dosed "s:/var/run/amavis/:$AMAVIS_ROOT/:g" /etc/init.d/amavisd

	keepdir ${AMAVIS_ROOT}
	fowners amavis:amavis ${AMAVIS_ROOT}
	fperms 0750 ${AMAVIS_ROOT}

	keepdir ${AMAVIS_ROOT}/db
	fowners amavis:amavis ${AMAVIS_ROOT}/db

	keepdir ${AMAVIS_ROOT}/quarantine
	fowners amavis:amavis ${AMAVIS_ROOT}/quarantine

	keepdir ${AMAVIS_ROOT}/tmp
	fowners amavis:amavis ${AMAVIS_ROOT}/tmp
	for i in whitelist blacklist spam_lovers; do
		touch ${D}${AMAVIS_ROOT}/${i}
		fowners amavis:amavis ${AMAVIS_ROOT}/${i}
	done

	newdoc test-messages/README README.samples
	dodoc AAAREADME.first INSTALL LDAP.schema LICENSE MANIFEST RELEASE_NOTES \
		README_FILES/* test-messages/sample-* amavisd.conf-default amavisd-agent

	if use milter ; then
		cd "${S}/helper-progs"
		einstall
	fi
}

pkg_postinst() {
	if `has_version mail-filter/razor` ; then
		einfo "Setting up initial razor config files..."

		razor-admin -create -home=${ROOT}${AMAVIS_ROOT}/.razor
		sed -i -e "s:debuglevel\([ ]*\)= .:debuglevel\1= 0:g" \
			${ROOT}${AMAVIS_ROOT}/.razor/razor-agent.conf
		chown -R amavis:amavis ${ROOT}${AMAVIS_ROOT}/.razor
	fi

	if ! `has_version mail-filter/spamassassin` ; then
		echo
		einfo "Amavisd-new no longer requires SpamAssassin, but no anti-spam checking"
		einfo "will be performed without it. Since you do not have SpamAssassin installed,"
		einfo "all spam checks have been disabled. To enable them, install SpamAssassin"
		einfo "and comment out line 170 of /etc/amavisd.conf."
	fi

	echo
	ewarn
	ewarn "This version of amavisd-new has a different layout from previous versions"
	ewarn "available in portage. The socket, pid, and lock file, as well as the"
	ewarn "temporary, razor, and spamassassin configuration directories have all"
	ewarn "moved to:"
	ewarn
	ewarn "${AMAVIS_ROOT}"
	ewarn
	ewarn "It may be necessary to reconfigure any helper applications."
	ewarn
}
