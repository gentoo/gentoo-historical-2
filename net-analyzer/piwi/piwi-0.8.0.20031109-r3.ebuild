# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/piwi/piwi-0.8.0.20031109-r3.ebuild,v 1.2 2004/09/06 18:58:36 ciaranm Exp $

inherit webapp eutils

DESCRIPTION="(Prelude|Perl) IDS Web Interface"
HOMEPAGE="http://www.prelude-ids.org"

# [LeRoutier] son, i'll keep this versionning scheme : x.y.z.t (x.y to
# match the major of prelude, z is piwi
#SRC_URI="http://www.leroutier.net/Projects/PreludeIDS/${PN}_v${PV}.tar.gz"
#SRC_URI="http://dev.gentoo.org/~mboman/distfiles/${PN}_v${PV}.tar.gz"
SRC_URI="mirror://gentoo/${PN}_v${PV}.tar.gz"

LICENSE="GPL-2"

KEYWORDS="~x86 ~sparc ~ppc"
IUSE="mysql postgres gd"
DEPEND=""
RDEPEND="
	dev-lang/perl
	dev-perl/DBI
	dev-perl/Date-Calc
	virtual/ghostscript
	dev-perl/Geo-IP
	postgres? ( dev-perl/DBD-Pg )
	mysql? ( dev-perl/DBD-mysql )
	gd? ( dev-perl/GDGraph )
"

S=${WORKDIR}/

src_compile() {
	if ! use mysql && ! use postgres; then
		eerror "You must have either MySQL or PostgreSQL enabled to use this software."
		eerror "You must put either 'mysql' or 'postgres' (or both) in your USE flags before emerging this."

		has_version ">=sys-apps/portage-2.0.50" && (
			einfo ""
			einfo "You can add the following line to /etc/portage/package.use"
			einfo "to permamently set this package's USE flags:"
			einfo ""
			einfo "net-analyzer/piwi [use flags]"
			einfo ""
		)
		exit 1
	fi
}


src_install() {
	webapp_src_preinst

	dodir ${D}${MY_HTDOCSDIR}
	dodir /etc/piwi

	# "install" the files into the destination
	cp -aR ${S}/* ${D}${MY_HTDOCSDIR}/ || die

	# Fix permissions
	chmod -R o-rwx ${D}${MY_HTDOCSDIR}/* || die

	# Move files around and create symlinks to make sure configuration files
	# are not being overwritten when you do upgrades...
	mv ${D}/${MY_HTDOCSDIR}/generated/Filters ${D}/etc/piwi/Filters || die
	dosym /etc/piwi/Filters ${MY_HTDOCSDIR}/generated/Filters || die

	mv ${D}/${MY_HTDOCSDIR}/Profiles ${D}/etc/piwi/Profiles || die
	dosym /etc/piwi/Profiles ${MY_HTDOCSDIR}/Profiles || die

	# default config.pl is looking for ghostscript in /usr/local/... that's not where
	# Gentoo has it.. So we do some sed magic to fix it..
	sed -i -e 's:/usr/local/bin/gs:/usr/bin/gs:' ${D}/${MY_HTDOCSDIR}/Functions/config.pl || die
	mv ${D}/${MY_HTDOCSDIR}/Functions/config.pl ${D}/etc/piwi/config.pl || die
	dosym /etc/piwi/config.pl ${MY_HTDOCSDIR}/Functions/config.pl || die

	# Install configuration file for apache
	insinto /etc/piwi
	doins ${FILESDIR}/piwi-apache.conf || die

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	einfo ""
	einfo "To have Apache run PIWI, please do the following:"
	einfo "1) Include the /etc/piwi/piwi-apache.conf in your apache configuration"
	einfo "2) Edit /etc/conf.d/apache or /etc/conf.d/apache2 and add \"-D PIWI\""
	einfo "3) Edit /etc/piwi/config.pl to reflect your settings"
	ewarn ""
	ewarn "NOTE: If you do not perform these steps PIWI will _not_ work."
	ewarn "      You have been warned. Any bugs against this will be either:"
	ewarn ""
	ewarn "       - directed to /dev/null"
	ewarn "       - resolved with a RTFM comment"
	ewarn ""
	ewarn "Consider yourself warned"
	# Make sure that the user pay attention
	ebeep 3
}
