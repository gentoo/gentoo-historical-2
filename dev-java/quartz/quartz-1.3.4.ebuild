# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/quartz/quartz-1.3.4.ebuild,v 1.1 2004/05/20 16:41:24 st_lim Exp $

inherit java-pkg
USE="oracle servlet-2.3 servlet-2.4 dbcp jboss jta jmx struts jikes"
DESCRIPTION="Quartz Scheduler from OpenSymphony"
HOMEPAGE="http://www.opensymphony.com/quartz/"
SRC_URI="mirror://sourceforge/quartz/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=virtual/jdk-1.4
		oracle? ( =dev-java/jdbc2-oracle-9.2.0.3 )
		servlet-2.3? ( =dev-java/servletapi-2.3-r1 )
		servlet-2.4? ( =dev-java/servletapi-2.4 )
		dbcp? ( =dev-java/commons-dbcp-1.1 )
		jboss? ( =net-www/jboss-3.2.3 )
		jta? ( =dev-java/jta-1.0.1 )
		jmx? ( =dev-java/jmx-1.2.1 )
		struts? ( =dev-java/struts-1.1 )
		jikes? ( dev-java/jikes )"

S=${WORKDIR}/${P}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	use servlet-2.3 && CLASSPATH="$CLASSPATH:`java-config -p servletapi-2.3`"
	use servlet-2.4 && CLASSPATH="$CLASSPATH:`java-config -p servletapi-2.4`"
	use dbcp && CLASSPATH="$CLASSPATH:`java-config -p commons-dbcp`"
	use jta && CLASSPATH="$CLASSPATH:`java-config -p jta`"
	use oracle && cp /usr/share/jdbc2-oracle-9.2.0.3/lib/classes12.zip ${S}/lib
	if [ `use jboss` ]; then
		echo "Using jboss"
		cp /usr/share/jboss/lib/jboss-common.jar ${S}/lib
		cp /usr/share/jboss/lib/jboss-jmx.jar ${S}/lib
		cp /usr/share/jboss/lib/jboss-system.jar ${S}/lib
		cp /var/lib/jboss/default/lib/jboss.jar ${S}/lib
		antflags="${antflags} -Dlib.jboss-common.jar=/usr/share/jboss/lib/jboss-common.jar"
		antflags="${antflags} -Dlib.jboss-jmx.jar=/usr/share/jboss/lib/jboss-jmx.jar"
		antflags="${antflags} -Dlib.jboss-system.jar=/usr/share/jboss/lib/jboss-system.jar"
		antflags="${antflags} -Dlib.jboss.jar=/var/lib/jboss/default/lib/jboss.jar"
	fi
	use struts && cp /usr/share/struts/lib/struts.jar ${S}/lib

	ant ${antflags} || die "compile failed"
}


src_install() {
	java-pkg_dojar lib/quartz.jar
	use doc && dohtml -r docs/
}
