# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_perl/mod_perl-1.99.10.ebuild,v 1.1 2005/05/09 10:20:52 beu Exp $

inherit eutils

front=${PV%\.*}
back=\_${PV##*\.}
MY_PV=${PV:0:${#front}}${back}

MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An embedded Perl interpreter for Apache2"
SRC_URI="http://perl.apache.org/dist/${MY_P}.tar.gz"
HOMEPAGE="http://perl.apache.org/"

LICENSE="GPL-2"
KEYWORDS="~x86 amd64"
IUSE=""
SLOT="1"

# see bug 30087 for why sudo is in here

DEPEND="dev-lang/perl
	=net-www/apache-2*
	>=dev-perl/CGI-2.93
	>=sys-apps/sed-4
	app-admin/sudo"

src_unpack() {
	unpack ${A}

	cd ${S}

	# I am not entirely happy with this solution, but here's what's
	# going on here if someone wants to take a stab at another
	# approach.  When userpriv compilation is off, then the make
	# process drops to user "nobody" to run the test servers.  This
	# server is closed, and then the socket is rebound using
	# SO_REUSEADDR.  If the same user does this, there is no problem,
	# and the socket may be rebound immediately.  If a different user
	# (yes, in my testing, even root) attempts to rebind, it fails.
	# Since the "is the socket available yet" code and the
	# second-batch bind call both run as root, this will fail.  

	# The upstream settings on my test machine cause the second batch
	# of tests to fail, believing the socket to still be in use.  I
	# tried patching various parts to make them run as the user
	# specified in $config->{vars}{user} using getpwnam, but found
	# this patch to be fairly intrusive, because the userid must be
	# restored and the patch must be applied to multiple places.

	# For now, we will simply extend the timeout in hopes that in the
	# non-userpriv case, the socket will clear from the kernel tables
	# normally, and the tests will proceed.

	# If anybody is still having problems, then commenting out "make
	# test" below should allow the software to build properly.

	# Robert Coie <rac@gentoo.org> 2003.05.06

	sed -i -e "s/sleep \$_/sleep \$_ << 2/" ${S}/Apache-Test/lib/Apache/TestServer.pm || die "problem editing TestServer.pm"

	# this one is because of sandbox problems trying to uninstall test.pm

	epatch ${FILESDIR}/${P}-nonukes.patch || die
}

src_compile() {
	perl Makefile.PL \
		PREFIX=${D}/usr \
		MP_TRACE=1 \
		MP_DEBUG=1 \
		MP_AP_PREFIX=/usr \
		MP_USE_DSO=1 \
		MP_INST_APACHE2=1 \
		MP_APXS=/usr/sbin/apxs2  \
		CCFLAGS="${CFLAGS} -fPIC" \
		INSTALLDIRS=vendor </dev/null || die

	emake || die

	# make test notes whether it is running as root, and drops
	# privileges all the way to "nobody" if so, so we must adjust
	# write permissions accordingly in this case.

	if [ "`id -u`" == '0' ]; then
		chown nobody:nobody ${WORKDIR}
		chown nobody:nobody ${T}
	fi

	# these next two stanzas avoid sandbox problems with make test
	# tell mod_cgid to make the socket here instead of /var/run/cgisock
	echo -e "\nScriptSock logs/cgisock" >> ${S}/t/conf/extra.conf.in
	echo -e "\nScriptSock logs/cgisock" >> ${S}/ModPerl-Registry/t/conf/extra.conf.in
	# tell CGI.pm to create new tmpfiles in this directory
	echo -e "\nSetEnv TMPDIR ${T}" >> ${S}/t/conf/extra.conf.in

	# this does not || die because of bug 21325.

	make test
}

src_install() {
	dodir /usr/lib/apache2-extramodules
	make install \
		MODPERL_AP_LIBEXECDIR=${D}/usr/lib/apache2-extramodules \
		MODPERL_AP_INCLUDEDIR=${D}/usr/include/apache2 \
		MP_INST_APACHE2=1 \
		INSTALLDIRS=vendor || die

	insinto /etc/apache2/conf/modules.d
	doins ${FILESDIR}/75_mod_perl.conf \
		${FILESDIR}/apache2-mod_perl-startup.pl

	dodoc ${FILESDIR}/75_mod_perl.conf Changes \
		INSTALL LICENSE README STATUS
	cp -a docs ${D}/usr/share/doc/${PF}
	cp -a todo ${D}/usr/share/doc/${PF}
}
